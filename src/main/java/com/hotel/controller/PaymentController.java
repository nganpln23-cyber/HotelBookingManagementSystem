package com.hotel.controller;

import com.hotel.model.Booking;
import com.hotel.service.BookingService;
import com.hotel.service.PaymentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@Controller
@RequestMapping("/admin/payments")
public class PaymentController {
    private final PaymentService paymentService;
    private final BookingService bookingService;

    public PaymentController(PaymentService paymentService, BookingService bookingService) {
        this.paymentService = paymentService;
        this.bookingService = bookingService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("payments", paymentService.findAll());
        return "payments/list";
    }

    @GetMapping("/new/{bookingId}")
    public String newPayment(@PathVariable("bookingId") Integer bookingId,
                              @RequestParam(name = "redirectAction", required = false) String redirectAction,
                              Model model) {
        model.addAttribute("booking", bookingService.findById(bookingId));
        model.addAttribute("amountDue", paymentService.getAmountDue(bookingId));
        model.addAttribute("redirectAction", redirectAction);
        return "payments/form";
    }

    @PostMapping("/pay")
    public String pay(@RequestParam("bookingId") Integer bookingId,
                       @RequestParam("amount") BigDecimal amount,
                       @RequestParam("method") String method,
                       @RequestParam(name = "note", required = false) String note,
                       @RequestParam(name = "redirectAction", required = false) String redirectAction) {
        paymentService.pay(bookingId, amount, method, note);
        Booking booking = bookingService.findById(bookingId);
        if ("CHECKED_IN".equals(booking.getStatus()) && paymentService.isFullyPaid(bookingId)) {
            bookingService.checkOut(bookingId);
        }
        if ("checkout".equals(redirectAction)) {
            return "redirect:/admin/checkinout";
        }
        return "redirect:/admin/payments";
    }
}
