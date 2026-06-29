package com.hotel.controller;

import com.hotel.model.Booking;
import com.hotel.model.Customer;
import com.hotel.model.Payment;
import com.hotel.service.BookingService;
import com.hotel.service.CustomerService;
import com.hotel.service.PaymentService;
import com.hotel.service.RoomService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/bookings")
public class BookingController {
    private final BookingService bookingService;
    private final CustomerService customerService;
    private final RoomService roomService;
    private final PaymentService paymentService;

    public BookingController(BookingService bookingService, CustomerService customerService,
                              RoomService roomService, PaymentService paymentService) {
        this.bookingService = bookingService;
        this.customerService = customerService;
        this.roomService = roomService;
        this.paymentService = paymentService;
    }

    @GetMapping
    public String list(Model model) {
        List<Booking> bookings = bookingService.findAll();
        Map<Integer, Boolean> fullyPaidMap = new HashMap<>();
        for (Booking b : bookings) {
            if ("CHECKED_IN".equals(b.getStatus())) {
                fullyPaidMap.put(b.getId(), paymentService.isFullyPaid(b.getId()));
            }
        }
        model.addAttribute("bookings", bookings);
        model.addAttribute("fullyPaidMap", fullyPaidMap);
        return "bookings/list";
    }

    @GetMapping("/calendar")
    public String calendar(Model model) {
        return "bookings/calendar";
    }

    @GetMapping("/calendar-events")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> calendarEvents() {
        List<Booking> bookings = bookingService.findAll();
        List<Map<String, Object>> events = new ArrayList<>();
        for (Booking b : bookings) {
            Map<String, Object> ev = new HashMap<>();
            ev.put("id", b.getId());
            ev.put("title", (b.getRoomNumber() != null ? b.getRoomNumber() : "?") + " - " + (b.getCustomerName() != null ? b.getCustomerName() : ""));
            ev.put("start", b.getCheckInDate().toString());
            ev.put("end", b.getCheckOutDate().toString());
            ev.put("status", b.getStatus());
            ev.put("url", "javascript:void(0)");
            String color = switch (b.getStatus()) {
                case "PENDING"     -> "#f59e0b";
                case "CONFIRMED"   -> "#4f46e5";
                case "CHECKED_IN"  -> "#10b981";
                case "CHECKED_OUT" -> "#64748b";
                case "CANCELLED"   -> "#ef4444";
                default            -> "#94a3b8";
            };
            ev.put("backgroundColor", color);
            ev.put("borderColor", color);
            ev.put("bookingId", b.getId());
            ev.put("customerName", b.getCustomerName());
            ev.put("roomNumber", b.getRoomNumber());
            ev.put("roomTypeName", b.getRoomTypeName());
            ev.put("totalAmount", b.getTotalAmount());
            ev.put("confirmationCode", b.getConfirmationCode());
            events.add(ev);
        }
        return ResponseEntity.ok(events);
    }

    @GetMapping("/invoice/{id}")
    public String invoice(@PathVariable("id") Integer id, Model model) {
        Booking booking = bookingService.findById(id);
        List<Payment> payments = paymentService.findByBookingId(id);
        model.addAttribute("booking", booking);
        model.addAttribute("payments", payments);
        model.addAttribute("amountDue", paymentService.getAmountDue(id));
        model.addAttribute("isFullyPaid", paymentService.isFullyPaid(id));
        return "bookings/invoice";
    }

    @GetMapping("/new")
    public String create(Model model) {
        Booking booking = new Booking();
        booking.setStatus("CONFIRMED");
        model.addAttribute("booking", booking);
        model.addAttribute("customers", customerService.findAll());
        model.addAttribute("rooms", roomService.findAll());
        return "bookings/form";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model) {
        model.addAttribute("booking", bookingService.findById(id));
        model.addAttribute("customers", customerService.findAll());
        model.addAttribute("rooms", roomService.findAll());
        return "bookings/form";
    }

    @PostMapping("/save")
    public String save(@Valid @ModelAttribute Booking booking, BindingResult result,
                        @RequestParam(name = "newCustomerFullName", required = false) String newCustomerFullName,
                        @RequestParam(name = "newCustomerPhone", required = false) String newCustomerPhone,
                        @RequestParam(name = "newCustomerEmail", required = false) String newCustomerEmail,
                        @RequestParam(name = "newCustomerIdentityNumber", required = false) String newCustomerIdentityNumber,
                        @RequestParam(name = "newCustomerAddress", required = false) String newCustomerAddress,
                        Model model) {
        // Kiểm tra phải có khách hàng: chọn sẵn hoặc tạo mới
        boolean hasNewCustomer = newCustomerFullName != null && !newCustomerFullName.isBlank();
        if (booking.getCustomerId() == null && !hasNewCustomer) {
            result.rejectValue("customerId", "required", "Vui lòng chọn hoặc nhập thông tin khách hàng");
        }

        // Kiểm tra ngày trả phòng phải sau ngày nhận phòng
        if (booking.getCheckInDate() != null && booking.getCheckOutDate() != null
                && !booking.getCheckOutDate().isAfter(booking.getCheckInDate())) {
            result.rejectValue("checkOutDate", "invalid", "Ngày trả phòng phải sau ngày nhận phòng");
        }

        if (result.hasErrors()) {
            model.addAttribute("error", result.getFieldErrors().stream()
                    .map(fe -> fe.getDefaultMessage())
                    .collect(Collectors.joining(" | ")));
            model.addAttribute("customers", customerService.findAll());
            model.addAttribute("rooms", roomService.findAll());
            return "bookings/form";
        }

        if (booking.getCustomerId() == null) {
            Customer customer = new Customer();
            customer.setFullName(newCustomerFullName);
            customer.setPhone(newCustomerPhone);
            customer.setEmail(newCustomerEmail);
            customer.setIdentityNumber(newCustomerIdentityNumber);
            customer.setAddress(newCustomerAddress);
            booking.setCustomerId(customerService.createAndReturnId(customer));
        }
        bookingService.save(booking);
        return "redirect:/admin/bookings";
    }

    @GetMapping("/confirm/{id}")
    public String confirm(@PathVariable("id") Integer id) {
        bookingService.confirm(id);
        return "redirect:/admin/bookings";
    }

    @GetMapping("/check-in/{id}")
    public String checkIn(@PathVariable("id") Integer id) {
        bookingService.checkIn(id);
        return "redirect:/admin/bookings";
    }

    @GetMapping("/check-out/{id}")
    public String checkOut(@PathVariable("id") Integer id) {
        bookingService.checkOut(id);
        return "redirect:/admin/bookings";
    }

    @GetMapping("/cancel/{id}")
    public String cancel(@PathVariable("id") Integer id) {
        bookingService.cancel(id);
        return "redirect:/admin/bookings";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        bookingService.delete(id);
        return "redirect:/admin/bookings";
    }
}
