package com.hotel.controller;

import com.hotel.model.Customer;
import com.hotel.service.CustomerService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/customers")
public class CustomerController {
    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    @GetMapping
    public String list(@RequestParam(name = "keyword", required = false) String keyword, Model model) {
        model.addAttribute("customers", customerService.search(keyword));
        model.addAttribute("keyword", keyword);
        return "customers/list";
    }

    @GetMapping("/new")
    public String create(Model model) {
        model.addAttribute("customer", new Customer());
        return "customers/form";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model) {
        model.addAttribute("customer", customerService.findById(id));
        return "customers/form";
    }

    @PostMapping("/save")
    public String save(@Valid @ModelAttribute Customer customer, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("error", result.getFieldErrors().stream()
                    .map(fe -> fe.getDefaultMessage())
                    .collect(Collectors.joining(" | ")));
            return "customers/form";
        }
        customerService.save(customer);
        return "redirect:/admin/customers";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        customerService.delete(id);
        return "redirect:/admin/customers";
    }
}
