package com.hotel.controller;

import com.hotel.model.Booking;
import com.hotel.model.Customer;
import com.hotel.service.BookingService;
import com.hotel.service.CustomerService;
import com.hotel.service.PaymentService;
import com.hotel.service.PromotionService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/account")
public class AccountController {
    private final CustomerService customerService;
    private final BookingService bookingService;
    private final PaymentService paymentService;
    private final PromotionService promotionService;

    public AccountController(CustomerService customerService, BookingService bookingService,
                              PaymentService paymentService, PromotionService promotionService) {
        this.customerService = customerService;
        this.bookingService = bookingService;
        this.paymentService = paymentService;
        this.promotionService = promotionService;
    }

    @GetMapping("/register")
    public String registerForm(HttpSession session, Model model) {
        if (session.getAttribute("currentCustomer") != null) {
            return "redirect:/account";
        }
        model.addAttribute("customer", new Customer());
        return "account/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute Customer customer, HttpSession session, Model model) {
        try {
            Customer saved = customerService.register(customer);
            session.setAttribute("currentCustomer", saved);
            return "redirect:/account";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("customer", customer);
            return "account/register";
        }
    }

    @GetMapping("/login")
    public String loginForm(HttpSession session) {
        if (session.getAttribute("currentCustomer") != null) {
            return "redirect:/account";
        }
        return "account/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                         @RequestParam("password") String password,
                         HttpSession session) {
        Customer customer = customerService.authenticate(email, password);
        if (customer == null) {
            return "redirect:/account/login?error=1";
        }
        session.setAttribute("currentCustomer", customer);
        return "redirect:/account";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("currentCustomer");
        return "redirect:/";
    }

    @GetMapping
    public String dashboard(HttpSession session, Model model) {
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        model.addAttribute("customer", customer);
        model.addAttribute("bookings", bookingService.findByCustomerId(customer.getId()));
        model.addAttribute("promotions", promotionService.findEligiblePromotions(customer.getId()));
        return "account/dashboard";
    }

    @GetMapping("/bookings/{id}")
    public String invoice(@PathVariable("id") Integer id, HttpSession session, Model model) {
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        Booking booking = bookingService.findById(id);
        if (booking == null || !booking.getCustomerId().equals(customer.getId())) {
            return "redirect:/account";
        }
        model.addAttribute("booking", booking);
        model.addAttribute("payments", paymentService.findByBooking(id));
        model.addAttribute("amountDue", paymentService.getAmountDue(id));
        return "account/invoice";
    }
}
