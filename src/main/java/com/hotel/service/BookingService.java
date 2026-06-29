package com.hotel.service;

import com.hotel.repository.BookingRepository;
import com.hotel.repository.PaymentRepository;
import com.hotel.model.Booking;
import com.hotel.model.Customer;
import com.hotel.model.PublicBookingForm;
import com.hotel.model.Room;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class BookingService {
    private final BookingRepository bookingRepository;
    private final PaymentRepository paymentRepository;
    private final RoomService roomService;
    private final CustomerService customerService;
    private final PromotionService promotionService;
    private final EmailService emailService;

    public BookingService(BookingRepository bookingRepository, PaymentRepository paymentRepository,
                          RoomService roomService, CustomerService customerService,
                          PromotionService promotionService, EmailService emailService) {
        this.bookingRepository = bookingRepository;
        this.paymentRepository = paymentRepository;
        this.roomService = roomService;
        this.customerService = customerService;
        this.promotionService = promotionService;
        this.emailService = emailService;
    }

    public List<Booking> findAll() { return bookingRepository.findAll(); }
    public Booking findById(Integer id) { return bookingRepository.findById(id); }
    public List<Booking> findByCustomerId(Integer customerId) { return bookingRepository.findByCustomerId(customerId); }

    /** Returns the dates within [from, to) on which every room is already booked. */
    public List<LocalDate> getFullyBookedDates(LocalDate from, LocalDate to) {
        long totalBookable = roomService.findAll().stream()
                .filter(r -> !"MAINTENANCE".equals(r.getStatus()))
                .count();
        if (totalBookable == 0) return List.of();

        List<Booking> active = bookingRepository.findActiveForRange(from, to);
        List<LocalDate> fullyBooked = new ArrayList<>();
        for (LocalDate d = from; d.isBefore(to); d = d.plusDays(1)) {
            final LocalDate date = d;
            long bookedRooms = active.stream()
                    .filter(b -> !b.getCheckInDate().isAfter(date) && b.getCheckOutDate().isAfter(date))
                    .map(Booking::getRoomId)
                    .distinct()
                    .count();
            if (bookedRooms >= totalBookable) fullyBooked.add(date);
        }
        return fullyBooked;
    }

    public BigDecimal calculateTotal(Booking b) {
        if (b.getRoomId() == null || b.getCheckInDate() == null || b.getCheckOutDate() == null) {
            return BigDecimal.ZERO;
        }
        Room room = roomService.findById(b.getRoomId());
        long nights = ChronoUnit.DAYS.between(b.getCheckInDate(), b.getCheckOutDate());
        if (nights < 1) nights = 1;
        return room.getRoomType().getPricePerNight().multiply(BigDecimal.valueOf(nights));
    }

    public void save(Booking b) {
        if (b.getRoomId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn phòng.");
        }
        if (b.getCheckInDate() == null || b.getCheckOutDate() == null) {
            throw new IllegalArgumentException("Vui lòng chọn ngày nhận phòng và ngày trả phòng.");
        }
        if (!b.getCheckOutDate().isAfter(b.getCheckInDate())) {
            throw new IllegalArgumentException("Ngày trả phòng phải sau ngày nhận phòng.");
        }
        if (b.getStatus() == null || b.getStatus().isBlank()) b.setStatus("PENDING");
        if (b.getStatus().equals("CONFIRMED") || b.getStatus().equals("CHECKED_IN")) {
            boolean conflict = b.getId() == null
                    ? bookingRepository.hasConfirmedOverlap(b.getRoomId(), b.getCheckInDate(), b.getCheckOutDate())
                    : bookingRepository.hasConfirmedOverlap(b.getRoomId(), b.getCheckInDate(), b.getCheckOutDate(), b.getId());
            if (conflict) {
                throw new IllegalArgumentException("Phòng đã được đặt (đã xác nhận) trong khoảng ngày này. Vui lòng chọn phòng hoặc ngày khác.");
            }
        }
        b.setTotalAmount(calculateTotal(b));
        Integer previousRoomId = null;
        if (b.getId() == null) {
            bookingRepository.insert(b);
        } else {
            previousRoomId = bookingRepository.findById(b.getId()).getRoomId();
            bookingRepository.update(b);
        }
        if (previousRoomId != null && !previousRoomId.equals(b.getRoomId())) {
            recheckRoomStatus(previousRoomId);
        }
        syncRoomStatus(b.getRoomId(), b.getStatus());
    }

    private void recheckRoomStatus(Integer roomId) {
        if (roomId == null) return;
        roomService.updateStatus(roomId, bookingRepository.findDominantBookingStatusForRoom(roomId));
    }

    private void syncRoomStatus(Integer roomId, String bookingStatus) {
        if (roomId == null || bookingStatus == null) return;
        switch (bookingStatus) {
            case "CONFIRMED" -> roomService.updateStatus(roomId, "BOOKED");
            case "CHECKED_IN" -> roomService.updateStatus(roomId, "OCCUPIED");
            case "CHECKED_OUT", "CANCELLED" -> recheckRoomStatus(roomId);
            default -> { }
        }
    }

    /** Creates a booking in AWAITING_PAYMENT status and returns its ID. */
    public int createPublicBooking(PublicBookingForm form, Customer loggedInCustomer) {
        validateBookingDetails(form);

        String promoCode = null;
        if (form.getPromoCode() != null && !form.getPromoCode().isBlank()) {
            promoCode = form.getPromoCode().trim().toUpperCase();
        }

        int customerId;
        String customerEmail;
        BigDecimal discountPercent = BigDecimal.ZERO;
        if (loggedInCustomer != null) {
            customerId = loggedInCustomer.getId();
            customerEmail = loggedInCustomer.getEmail();
            if (promoCode != null) {
                discountPercent = promotionService.validate(promoCode, customerId);
            }
        } else {
            validateGuestInfo(form);
            if (promoCode != null) {
                discountPercent = promotionService.validate(promoCode, 0);
            }
            Customer customer = new Customer();
            customer.setFullName(form.getFullName());
            customer.setPhone(form.getPhone());
            customer.setEmail(form.getEmail());
            customer.setIdentityNumber(form.getIdentityNumber());
            customer.setAddress(form.getAddress());
            customerId = customerService.createAndReturnId(customer);
            customerEmail = form.getEmail();
        }

        Booking booking = new Booking();
        booking.setCustomerId(customerId);
        booking.setRoomId(form.getRoomId());
        booking.setCheckInDate(form.getCheckInDate());
        booking.setCheckOutDate(form.getCheckOutDate());
        booking.setStatus("AWAITING_PAYMENT");
        booking.setNote(form.getNote());
        booking.setPromoCode(promoCode);
        booking.setCustomerEmail(customerEmail);

        BigDecimal subtotal = calculateTotal(booking);
        BigDecimal discountAmount = subtotal.multiply(discountPercent).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        booking.setDiscountAmount(discountAmount);
        booking.setTotalAmount(subtotal.subtract(discountAmount));
        return bookingRepository.insert(booking);
    }

    /** Processes the online payment: creates payment record, moves booking to PENDING, sends email. */
    public void processOnlinePayment(Integer bookingId, String paymentRef) {
        Booking b = findById(bookingId);
        if (!"AWAITING_PAYMENT".equals(b.getStatus())) return;

        com.hotel.model.Payment payment = new com.hotel.model.Payment();
        payment.setBookingId(bookingId);
        payment.setAmount(b.getTotalAmount());
        payment.setMethod("ONLINE");
        payment.setStatus("PAID");
        payment.setNote("Thanh toán online. Mã GD: " + paymentRef);
        paymentRepository.insert(payment);

        bookingRepository.updateOnlinePayment(bookingId, paymentRef);
        bookingRepository.updateStatus(bookingId, "PENDING");

        String email = b.getCustomerEmail();
        if (email == null || email.isBlank()) {
            email = resolveCustomerEmail(b.getCustomerId());
        }
        if (email != null && !email.isBlank()) {
            b.setOnlinePaid(true);
            b.setOnlinePaymentRef(paymentRef);
            emailService.sendPaymentReceived(email, b.getCustomerName(), b);
        }
    }

    /** Cancels a booking stuck in AWAITING_PAYMENT (customer abandoned payment). */
    public void cancelAwaitingPayment(Integer id) {
        Booking b = findById(id);
        if ("AWAITING_PAYMENT".equals(b.getStatus())) {
            bookingRepository.updateStatus(id, "CANCELLED");
            recheckRoomStatus(b.getRoomId());
        }
    }

    private String resolveCustomerEmail(Integer customerId) {
        try {
            Customer c = customerService.findById(customerId);
            return c != null ? c.getEmail() : null;
        } catch (Exception e) {
            return null;
        }
    }

    private void validateGuestInfo(PublicBookingForm form) {
        if (form.getFullName() == null || form.getFullName().isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập họ tên.");
        }
        if (form.getPhone() == null || form.getPhone().isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập số điện thoại.");
        }
    }

    private void validateBookingDetails(PublicBookingForm form) {
        if (form.getRoomId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn phòng.");
        }

        LocalDate checkInDate = form.getCheckInDate();
        LocalDate checkOutDate = form.getCheckOutDate();
        if (checkInDate == null || checkOutDate == null) {
            throw new IllegalArgumentException("Vui lòng chọn ngày nhận và ngày trả phòng.");
        }
        if (!checkOutDate.isAfter(checkInDate)) {
            throw new IllegalArgumentException("Ngày trả phòng phải sau ngày nhận phòng.");
        }

        Room room = roomService.findById(form.getRoomId());
        if (room == null || "MAINTENANCE".equals(room.getStatus())) {
            throw new IllegalArgumentException("Phòng đã chọn hiện đang bảo trì, không thể đặt.");
        }
        if (bookingRepository.hasActiveOverlap(form.getRoomId(), checkInDate, checkOutDate)) {
            throw new IllegalArgumentException("Phòng đã có booking trong khoảng ngày này.");
        }
    }

    public List<Booking> findActiveBookings() {
        return bookingRepository.findByStatuses("PENDING", "CONFIRMED", "CHECKED_IN");
    }

    public void confirm(Integer id) {
        Booking b = findById(id);

        if (!b.getStatus().equals("PENDING")) {
            throw new IllegalStateException("Chỉ có thể xác nhận đơn đặt phòng ở trạng thái PENDING. Trạng thái hiện tại: " + b.getStatus());
        }

        if (!bookingRepository.hasConfirmedOverlap(b.getRoomId(), b.getCheckInDate(), b.getCheckOutDate())) {
            bookingRepository.updateStatus(id, "CONFIRMED");
            roomService.updateStatus(b.getRoomId(), "BOOKED");
            String code = "BK" + String.format("%06d", id);
            bookingRepository.updateConfirmationCode(id, code);

            if (b.isOnlinePaid()) {
                String email = b.getCustomerEmail();
                if (email == null || email.isBlank()) email = resolveCustomerEmail(b.getCustomerId());
                if (email != null && !email.isBlank()) {
                    b.setConfirmationCode(code);
                    emailService.sendBookingConfirmed(email, b.getCustomerName(), b);
                }
            }
        } else {
            throw new IllegalStateException("Phòng này đã được đặt trong khoảng thời gian này. Không thể xác nhận.");
        }
    }

    public void checkIn(Integer id) {
        Booking b = findById(id);
        if (!b.getStatus().equals("CONFIRMED")) {
            throw new IllegalStateException("Chỉ có thể check-in đơn đặt phòng ở trạng thái CONFIRMED. Trạng thái hiện tại: " + b.getStatus());
        }
        bookingRepository.updateStatus(id, "CHECKED_IN");
        roomService.updateStatus(b.getRoomId(), "OCCUPIED");
        String code = "CI" + UUID.randomUUID().toString().replace("-","").substring(0,8).toUpperCase();
        bookingRepository.updateCheckinCode(id, code);
    }

    public void checkOut(Integer id) {
        Booking b = findById(id);
        if (!b.getStatus().equals("CHECKED_IN")) {
            throw new IllegalStateException("Chỉ có thể check-out đơn đặt phòng ở trạng thái CHECKED_IN. Trạng thái hiện tại: " + b.getStatus());
        }
        BigDecimal paid = paymentRepository.sumPaidByBooking(id);
        if (paid == null || paid.compareTo(b.getTotalAmount()) < 0) {
            throw new IllegalStateException("Khách hàng chưa thanh toán đủ. Vui lòng thanh toán trước khi check-out.");
        }
        bookingRepository.updateStatus(id, "CHECKED_OUT");
        recheckRoomStatus(b.getRoomId());
    }

    public void cancel(Integer id) {
        Booking b = findById(id);
        if (!b.getStatus().equals("PENDING") && !b.getStatus().equals("CONFIRMED") && !b.getStatus().equals("AWAITING_PAYMENT")) {
            throw new IllegalStateException("Chỉ có thể hủy đơn đặt phòng ở trạng thái PENDING, CONFIRMED hoặc AWAITING_PAYMENT. Trạng thái hiện tại: " + b.getStatus());
        }
        bookingRepository.updateStatus(id, "CANCELLED");
        recheckRoomStatus(b.getRoomId());
    }

    public void delete(Integer id) {
        Booking b = findById(id);
        if (b.getStatus().equals("CHECKED_IN") || b.getStatus().equals("CONFIRMED")) {
            throw new IllegalStateException("Không thể xóa đơn đặt phòng đang hoạt động. Vui lòng hủy trước.");
        }
        Integer roomId = b.getRoomId();
        paymentRepository.deleteByBookingId(id);
        bookingRepository.delete(id);
        recheckRoomStatus(roomId);
    }

    public void syncAllRoomStatuses() {
        roomService.findAll().forEach(r -> recheckRoomStatus(r.getId()));
    }
}
