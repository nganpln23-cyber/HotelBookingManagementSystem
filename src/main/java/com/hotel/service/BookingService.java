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

@Service
public class BookingService {
    private final BookingRepository bookingRepository;
    private final PaymentRepository paymentRepository;
    private final RoomService roomService;
    private final CustomerService customerService;
    private final PromotionService promotionService;

    public BookingService(BookingRepository bookingRepository, PaymentRepository paymentRepository, RoomService roomService, CustomerService customerService, PromotionService promotionService) {
        this.bookingRepository = bookingRepository;
        this.paymentRepository = paymentRepository;
        this.roomService = roomService;
        this.customerService = customerService;
        this.promotionService = promotionService;
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
            roomService.updateStatus(previousRoomId, "AVAILABLE");
        }
        syncRoomStatus(b.getRoomId(), b.getStatus());
    }

    private void syncRoomStatus(Integer roomId, String bookingStatus) {
        if (roomId == null || bookingStatus == null) return;
        switch (bookingStatus) {
            case "CONFIRMED" -> roomService.updateStatus(roomId, "BOOKED");
            case "CHECKED_IN" -> roomService.updateStatus(roomId, "OCCUPIED");
            case "CHECKED_OUT", "CANCELLED" -> roomService.updateStatus(roomId, "AVAILABLE");
            default -> { }
        }
    }

    public void createPublicBooking(PublicBookingForm form, Customer loggedInCustomer) {
        validateBookingDetails(form);

        String promoCode = null;
        if (form.getPromoCode() != null && !form.getPromoCode().isBlank()) {
            promoCode = form.getPromoCode().trim().toUpperCase();
        }

        int customerId;
        BigDecimal discountPercent = BigDecimal.ZERO;
        if (loggedInCustomer != null) {
            customerId = loggedInCustomer.getId();
            if (promoCode != null) {
                discountPercent = promotionService.validate(promoCode, customerId);
            }
        } else {
            validateGuestInfo(form);
            if (promoCode != null) {
                // A brand-new guest customer has no completed bookings yet, so validate against that.
                discountPercent = promotionService.validate(promoCode, 0);
            }
            Customer customer = new Customer();
            customer.setFullName(form.getFullName());
            customer.setPhone(form.getPhone());
            customer.setEmail(form.getEmail());
            customer.setIdentityNumber(form.getIdentityNumber());
            customer.setAddress(form.getAddress());
            customerId = customerService.createAndReturnId(customer);
        }

        Booking booking = new Booking();
        booking.setCustomerId(customerId);
        booking.setRoomId(form.getRoomId());
        booking.setCheckInDate(form.getCheckInDate());
        booking.setCheckOutDate(form.getCheckOutDate());
        booking.setStatus("PENDING");
        booking.setNote(form.getNote());
        booking.setPromoCode(promoCode);

        BigDecimal subtotal = calculateTotal(booking);
        BigDecimal discountAmount = subtotal.multiply(discountPercent).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        booking.setDiscountAmount(discountAmount);
        booking.setTotalAmount(subtotal.subtract(discountAmount));
        bookingRepository.insert(booking);
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
        if (room == null || !"AVAILABLE".equals(room.getStatus())) {
            throw new IllegalArgumentException("Phòng đã chọn hiện không còn trống.");
        }
        if (bookingRepository.hasActiveOverlap(form.getRoomId(), checkInDate, checkOutDate)) {
            throw new IllegalArgumentException("Phòng đã có booking trong khoảng ngày này.");
        }
    }

    public void confirm(Integer id) {
        Booking b = findById(id);
        
        if (!b.getStatus().equals("PENDING")) {
            throw new IllegalStateException("Chỉ có thể xác nhận đơn đặt phòng ở trạng thái PENDING. Trạng thái hiện tại: " + b.getStatus());
        }
        
        if (!bookingRepository.hasConfirmedOverlap(b.getRoomId(), b.getCheckInDate(), b.getCheckOutDate())) {
            bookingRepository.updateStatus(id, "CONFIRMED");
            roomService.updateStatus(b.getRoomId(), "BOOKED");
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
    }

    public void checkOut(Integer id) {
        Booking b = findById(id);
        if (!b.getStatus().equals("CHECKED_IN")) {
            throw new IllegalStateException("Chỉ có thể check-out đơn đặt phòng ở trạng thái CHECKED_IN. Trạng thái hiện tại: " + b.getStatus());
        }
        bookingRepository.updateStatus(id, "CHECKED_OUT");
        roomService.updateStatus(b.getRoomId(), "AVAILABLE");
    }

    public void cancel(Integer id) {
        Booking b = findById(id);
        if (!b.getStatus().equals("PENDING") && !b.getStatus().equals("CONFIRMED")) {
            throw new IllegalStateException("Chỉ có thể hủy đơn đặt phòng ở trạng thái PENDING hoặc CONFIRMED. Trạng thái hiện tại: " + b.getStatus());
        }
        bookingRepository.updateStatus(id, "CANCELLED");
        roomService.updateStatus(b.getRoomId(), "AVAILABLE");
    }

    public void delete(Integer id) {
        Booking b = findById(id);
        if (b.getStatus().equals("CHECKED_IN") || b.getStatus().equals("CONFIRMED")) {
            throw new IllegalStateException("Không thể xóa đơn đặt phòng đang hoạt động. Vui lòng hủy trước.");
        }
        paymentRepository.deleteByBookingId(id);
        bookingRepository.delete(id);
    }
}
