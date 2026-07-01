package com.hotel.controller;

import com.hotel.model.Booking;
import com.hotel.model.Customer;
import com.hotel.model.PublicBookingForm;
import com.hotel.model.Room;
import com.hotel.model.RoomType;
import com.hotel.service.BookingService;
import com.hotel.service.RoomService;
import com.hotel.service.RoomTypeService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
public class PublicController {
    private static final int AVAILABILITY_WINDOW_DAYS = 60;

    private final RoomService roomService;
    private final BookingService bookingService;
    private final RoomTypeService roomTypeService;

    public PublicController(RoomService roomService, BookingService bookingService, RoomTypeService roomTypeService) {
        this.roomService = roomService;
        this.bookingService = bookingService;
        this.roomTypeService = roomTypeService;
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("rooms", roomService.findAvailable());
        model.addAttribute("roomTypes", roomTypeService.findAll());
        addAvailabilityCalendar(model);
        return "public/home";
    }

    @GetMapping("/rooms")
    public String rooms(@RequestParam(name = "checkIn", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkIn,
                         @RequestParam(name = "checkOut", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkOut,
                         @RequestParam(name = "roomTypeId", required = false) Integer roomTypeId,
                         Model model) {
        List<Room> rooms;
        boolean datesProvided = checkIn != null && checkOut != null && checkOut.isAfter(checkIn);
        if (datesProvided) {
            rooms = roomService.findAvailableForDates(checkIn, checkOut);
        } else {
            rooms = List.of();
        }
        model.addAttribute("datesProvided", datesProvided);
        if (roomTypeId != null) {
            rooms = rooms.stream().filter(r -> roomTypeId.equals(r.getRoomTypeId())).collect(Collectors.toList());
        }
        model.addAttribute("rooms", rooms);
        model.addAttribute("roomTypes", roomTypeService.findAll());
        model.addAttribute("checkIn", checkIn);
        model.addAttribute("checkOut", checkOut);
        model.addAttribute("roomTypeId", roomTypeId);
        addAvailabilityCalendar(model);
        return "public/rooms";
    }

    @GetMapping("/booking/new")
    public String bookingForm(@RequestParam(name = "roomId", required = false) Integer roomId,
                               @RequestParam(name = "checkIn", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkIn,
                               @RequestParam(name = "checkOut", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkOut,
                               HttpSession session,
                               Model model) {
        PublicBookingForm form = new PublicBookingForm();
        form.setRoomId(roomId);
        form.setCheckInDate(checkIn);
        form.setCheckOutDate(checkOut);

        Customer currentCustomer = (Customer) session.getAttribute("currentCustomer");
        if (currentCustomer != null) {
            form.setFullName(currentCustomer.getFullName());
            form.setPhone(currentCustomer.getPhone());
            form.setEmail(currentCustomer.getEmail());
            form.setIdentityNumber(currentCustomer.getIdentityNumber());
            form.setAddress(currentCustomer.getAddress());
        }

        model.addAttribute("bookingForm", form);
        model.addAttribute("currentCustomer", currentCustomer);
        List<Room> availableRooms = (checkIn != null && checkOut != null && checkOut.isAfter(checkIn))
                ? roomService.findAvailableForDates(checkIn, checkOut)
                : roomService.findAvailable();
        model.addAttribute("rooms", availableRooms);
        if (roomId != null) {
            model.addAttribute("selectedRoom", roomService.findById(roomId));
        }
        addAvailabilityCalendar(model);
        return "public/book";
    }

    @GetMapping("/room-types/{id}/image")
    public void roomTypeImage(@PathVariable("id") Integer id, HttpServletResponse response) throws IOException {
        RoomType image = roomTypeService.findImageById(id);
        if (image == null || image.getImageData() == null) {
            response.sendError(HttpStatus.NOT_FOUND.value());
            return;
        }
        response.setContentType(image.getImageContentType() != null ? image.getImageContentType() : "application/octet-stream");
        response.getOutputStream().write(image.getImageData());
    }

    private void addAvailabilityCalendar(Model model) {
        LocalDate today = LocalDate.now();
        model.addAttribute("fullyBookedDates",
                bookingService.getFullyBookedDates(today, today.plusDays(AVAILABILITY_WINDOW_DAYS)));
    }

    @PostMapping("/booking/save")
    public String saveBooking(@ModelAttribute PublicBookingForm bookingForm, HttpSession session, Model model) {
        Customer currentCustomer = (Customer) session.getAttribute("currentCustomer");
        try {
            int bookingId = bookingService.createPublicBooking(bookingForm, currentCustomer);
            return "redirect:/booking/payment/" + bookingId;
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("bookingForm", bookingForm);
            model.addAttribute("currentCustomer", currentCustomer);
            LocalDate ci = bookingForm.getCheckInDate();
            LocalDate co = bookingForm.getCheckOutDate();
            List<Room> availRooms = (ci != null && co != null && co.isAfter(ci))
                    ? roomService.findAvailableForDates(ci, co)
                    : roomService.findAvailable();
            model.addAttribute("rooms", availRooms);
            if (bookingForm.getRoomId() != null) {
                model.addAttribute("selectedRoom", roomService.findById(bookingForm.getRoomId()));
            }
            addAvailabilityCalendar(model);
            return "public/book";
        }
    }

    @GetMapping("/booking/payment/{id}")
    public String paymentPage(@PathVariable("id") Integer id, Model model) {
        Booking booking;
        try { booking = bookingService.findById(id); } catch (Exception e) { return "redirect:/"; }
        if (booking == null) return "redirect:/";
        if ("PENDING".equals(booking.getStatus()) || "CONFIRMED".equals(booking.getStatus())) {
            return "redirect:/booking/success/" + id;
        }
        if (!"AWAITING_PAYMENT".equals(booking.getStatus())) return "redirect:/";
        long nights = ChronoUnit.DAYS.between(booking.getCheckInDate(), booking.getCheckOutDate());
        model.addAttribute("booking", booking);
        model.addAttribute("nights", nights);
        return "public/payment";
    }

    @PostMapping("/booking/payment/{id}/process")
    public String processPayment(@PathVariable("id") Integer id) {
        try {
            String txnId = "GBH" + UUID.randomUUID().toString().replace("-", "").substring(0, 12).toUpperCase();
            bookingService.processOnlinePayment(id, txnId);
        } catch (Exception ignored) {}
        return "redirect:/booking/success/" + id;
    }

    @GetMapping("/booking/success/{id}")
    public String paymentSuccess(@PathVariable("id") Integer id, Model model) {
        Booking booking;
        try { booking = bookingService.findById(id); } catch (Exception e) { return "redirect:/"; }
        if (booking == null) return "redirect:/";
        long nights = ChronoUnit.DAYS.between(booking.getCheckInDate(), booking.getCheckOutDate());
        model.addAttribute("booking", booking);
        model.addAttribute("nights", nights);
        return "public/payment-success";
    }

    @GetMapping("/booking/cancel-payment/{id}")
    public String cancelPayment(@PathVariable("id") Integer id) {
        try { bookingService.cancelAwaitingPayment(id); } catch (Exception ignored) {}
        return "redirect:/rooms";
    }
}
