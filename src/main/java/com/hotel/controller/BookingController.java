package com.hotel.controller;

import com.hotel.model.Booking;
import com.hotel.model.Customer;
import com.hotel.service.BookingService;
import com.hotel.service.CustomerService;
import com.hotel.service.RoomService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/bookings")
public class BookingController {
    private final BookingService bookingService;
    private final CustomerService customerService;
    private final RoomService roomService;

    public BookingController(BookingService bookingService, CustomerService customerService, RoomService roomService) {
        this.bookingService = bookingService;
        this.customerService = customerService;
        this.roomService = roomService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("bookings", bookingService.findAll());
        return "bookings/list";
    }

    @GetMapping("/new")
    public String create(Model model) {
        Booking booking = new Booking();
        booking.setStatus("PENDING");
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
    public String save(@ModelAttribute Booking booking,
                        @RequestParam(name = "newCustomerFullName", required = false) String newCustomerFullName,
                        @RequestParam(name = "newCustomerPhone", required = false) String newCustomerPhone,
                        @RequestParam(name = "newCustomerEmail", required = false) String newCustomerEmail,
                        @RequestParam(name = "newCustomerIdentityNumber", required = false) String newCustomerIdentityNumber,
                        @RequestParam(name = "newCustomerAddress", required = false) String newCustomerAddress) {
        if (booking.getCustomerId() == null && newCustomerFullName != null && !newCustomerFullName.isBlank()) {
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
