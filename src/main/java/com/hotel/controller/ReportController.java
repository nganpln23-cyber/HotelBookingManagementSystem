package com.hotel.controller;

import com.hotel.service.ReportService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/reports")
public class ReportController {
    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @GetMapping("/revenue")
    public String revenue(
            @RequestParam(name = "from", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(name = "to", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            @RequestParam(name = "tab", required = false, defaultValue = "daily") String tab,
            @RequestParam(name = "year", required = false) Integer year,
            Model model) {

        LocalDate today = LocalDate.now();
        if (to == null) to = today;
        if (from == null) from = today.withDayOfMonth(1);
        if (year == null) year = today.getYear();

        model.addAttribute("report", reportService.getRevenueReport(from, to));
        model.addAttribute("monthlyData", reportService.getMonthlyReport(year));
        model.addAttribute("yearlyData", reportService.getYearlyReport());
        model.addAttribute("quarterlyData", reportService.getQuarterlyReport(year));
        model.addAttribute("tab", tab);
        model.addAttribute("selectedYear", year);
        model.addAttribute("currentYear", today.getYear());
        return "reports/revenue";
    }

    @GetMapping("/top-customers")
    public String topCustomers(
            @RequestParam(name = "limit", required = false, defaultValue = "10") int limit,
            Model model) {
        if (limit != 5 && limit != 10 && limit != 20) limit = 10;
        model.addAttribute("topCustomers", reportService.getTopCustomers(limit));
        model.addAttribute("limit", limit);
        return "reports/top-customers";
    }
}
