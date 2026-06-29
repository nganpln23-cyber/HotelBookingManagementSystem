package com.hotel.controller;

import com.hotel.model.Employee;
import com.hotel.service.EmployeeService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/employees")
public class EmployeeController {
    private final EmployeeService employeeService;

    public EmployeeController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    @GetMapping
    public String list(@RequestParam(name = "q", required = false) String q, Model model) {
        model.addAttribute("employees", q != null && !q.isBlank()
                ? employeeService.search(q) : employeeService.findAll());
        model.addAttribute("q", q);
        return "employees/list";
    }

    @GetMapping("/new")
    public String create(Model model) {
        model.addAttribute("employee", new Employee());
        return "employees/form";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Integer id, Model model) {
        model.addAttribute("employee", employeeService.findById(id));
        return "employees/form";
    }

    @PostMapping("/save")
    public String save(@Valid @ModelAttribute Employee employee, BindingResult result,
                       Model model, RedirectAttributes ra) {
        if (result.hasErrors()) {
            model.addAttribute("error", result.getFieldErrors().stream()
                    .map(fe -> fe.getDefaultMessage())
                    .collect(Collectors.joining(" | ")));
            return "employees/form";
        }
        employeeService.save(employee);
        ra.addFlashAttribute("success", "Lưu thông tin nhân viên thành công.");
        return "redirect:/admin/employees";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes ra) {
        employeeService.delete(id);
        ra.addFlashAttribute("success", "Đã xóa nhân viên.");
        return "redirect:/admin/employees";
    }
}
