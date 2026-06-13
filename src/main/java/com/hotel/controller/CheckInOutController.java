package com.hotel.controller;

import com.hotel.model.Booking;
import com.hotel.service.BookingService;
import com.hotel.service.PaymentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/checkinout")
public class CheckInOutController {
    private final BookingService bookingService;
    private final PaymentService paymentService;

    public CheckInOutController(BookingService bookingService, PaymentService paymentService) {
        this.bookingService = bookingService;
        this.paymentService = paymentService;
    }

    @GetMapping
    public String index(Model model) {
        List<Booking> all = bookingService.findAll();
        List<Booking> confirmedBookings = all.stream()
                .filter(b -> "CONFIRMED".equals(b.getStatus()))
                .collect(Collectors.toList());
        List<Booking> checkedInBookings = all.stream()
                .filter(b -> "CHECKED_IN".equals(b.getStatus()))
                .collect(Collectors.toList());

        Map<Integer, BigDecimal> amountDueMap = new HashMap<>();
        Map<Integer, Boolean> fullyPaidMap = new HashMap<>();
        for (Booking b : checkedInBookings) {
            amountDueMap.put(b.getId(), paymentService.getAmountDue(b.getId()));
            fullyPaidMap.put(b.getId(), paymentService.isFullyPaid(b.getId()));
        }

        model.addAttribute("confirmedBookings", confirmedBookings);
        model.addAttribute("checkedInBookings", checkedInBookings);
        model.addAttribute("amountDueMap", amountDueMap);
        model.addAttribute("fullyPaidMap", fullyPaidMap);
        return "checkinout/index";
    }

    @GetMapping("/check-in/{id}")
    public String checkIn(@PathVariable("id") Integer id) {
        bookingService.checkIn(id);
        return "redirect:/admin/checkinout";
    }

    @GetMapping("/check-out/{id}")
    public String checkOut(@PathVariable("id") Integer id) {
        if (paymentService.isFullyPaid(id)) {
            bookingService.checkOut(id);
            return "redirect:/admin/checkinout";
        }
        return "redirect:/admin/payments/new/" + id + "?redirectAction=checkout";
    }
}
