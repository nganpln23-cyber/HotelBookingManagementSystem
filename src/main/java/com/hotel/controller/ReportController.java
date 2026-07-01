package com.hotel.controller;

import com.hotel.service.ExportService;
import com.hotel.service.ReportService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.time.LocalDate;

@Controller
@RequestMapping("/admin/reports")
public class ReportController {
    private final ReportService reportService;
    private final ExportService exportService;

    public ReportController(ReportService reportService, ExportService exportService) {
        this.reportService = reportService;
        this.exportService = exportService;
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

    @GetMapping("/revenue/export")
    public ResponseEntity<byte[]> exportRevenue(
            @RequestParam(name = "format") String format,
            @RequestParam(name = "tab", defaultValue = "daily") String tab,
            @RequestParam(name = "from", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(name = "to", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            @RequestParam(name = "year", required = false) Integer year) throws IOException {

        LocalDate today = LocalDate.now();
        if (to == null) to = today;
        if (from == null) from = today.withDayOfMonth(1);
        if (year == null) year = today.getYear();

        byte[] data;
        String filename;
        String contentType;

        boolean isExcel = "xlsx".equalsIgnoreCase(format);
        contentType = isExcel
                ? "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                : "application/pdf";
        String ext = isExcel ? ".xlsx" : ".pdf";

        switch (tab) {
            case "monthly":
                data = isExcel
                        ? exportService.exportRevenueMonthly(reportService.getMonthlyReport(year), year)
                        : exportService.exportRevenueMonthlyPdf(reportService.getMonthlyReport(year), year);
                filename = "doanh-thu-thang-" + year + ext;
                break;
            case "quarterly":
                data = isExcel
                        ? exportService.exportRevenueQuarterly(reportService.getQuarterlyReport(year), year)
                        : exportService.exportRevenueQuarterlyPdf(reportService.getQuarterlyReport(year), year);
                filename = "doanh-thu-quy-" + year + ext;
                break;
            case "yearly":
                data = isExcel
                        ? exportService.exportRevenueYearly(reportService.getYearlyReport())
                        : exportService.exportRevenueYearlyPdf(reportService.getYearlyReport());
                filename = "doanh-thu-nam" + ext;
                break;
            default:
                data = isExcel
                        ? exportService.exportRevenueDaily(reportService.getRevenueReport(from, to))
                        : exportService.exportRevenueDailyPdf(reportService.getRevenueReport(from, to));
                filename = "doanh-thu-ngay-" + from + "-den-" + to + ext;
        }

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.parseMediaType(contentType))
                .body(data);
    }

    @GetMapping("/occupancy")
    public String occupancy(
            @RequestParam(name = "tab", required = false, defaultValue = "monthly") String tab,
            @RequestParam(name = "year", required = false) Integer year,
            Model model) {
        LocalDate today = LocalDate.now();
        if (year == null) year = today.getYear();
        model.addAttribute("monthlyData", reportService.getMonthlyOccupancy(year));
        model.addAttribute("quarterlyData", reportService.getQuarterlyOccupancy(year));
        model.addAttribute("yearlyData", reportService.getYearlyOccupancy());
        model.addAttribute("tab", tab);
        model.addAttribute("selectedYear", year);
        model.addAttribute("currentYear", today.getYear());
        return "reports/occupancy";
    }

    @GetMapping("/occupancy/export")
    public ResponseEntity<byte[]> exportOccupancy(
            @RequestParam(name = "format") String format,
            @RequestParam(name = "tab", defaultValue = "monthly") String tab,
            @RequestParam(name = "year", required = false) Integer year) throws IOException {
        LocalDate today = LocalDate.now();
        if (year == null) year = today.getYear();

        boolean isExcel = "xlsx".equalsIgnoreCase(format);
        String ext = isExcel ? ".xlsx" : ".pdf";
        String contentType = isExcel
                ? "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                : "application/pdf";

        byte[] data;
        String filename;
        switch (tab) {
            case "quarterly":
                data = isExcel
                        ? exportService.exportOccupancyQuarterly(reportService.getQuarterlyOccupancy(year), year)
                        : exportService.exportOccupancyQuarterlyPdf(reportService.getQuarterlyOccupancy(year), year);
                filename = "ty-le-lap-day-quy-" + year + ext;
                break;
            case "yearly":
                data = isExcel
                        ? exportService.exportOccupancyYearly(reportService.getYearlyOccupancy())
                        : exportService.exportOccupancyYearlyPdf(reportService.getYearlyOccupancy());
                filename = "ty-le-lap-day-nam" + ext;
                break;
            default:
                data = isExcel
                        ? exportService.exportOccupancyMonthly(reportService.getMonthlyOccupancy(year), year)
                        : exportService.exportOccupancyMonthlyPdf(reportService.getMonthlyOccupancy(year), year);
                filename = "ty-le-lap-day-thang-" + year + ext;
        }

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.parseMediaType(contentType))
                .body(data);
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

    @GetMapping("/top-customers/export")
    public ResponseEntity<byte[]> exportTopCustomers(
            @RequestParam(name = "format") String format,
            @RequestParam(name = "limit", defaultValue = "10") int limit) throws IOException {
        if (limit != 5 && limit != 10 && limit != 20) limit = 10;

        boolean isExcel = "xlsx".equalsIgnoreCase(format);
        byte[] data = isExcel
                ? exportService.exportTopCustomers(reportService.getTopCustomers(limit))
                : exportService.exportTopCustomersPdf(reportService.getTopCustomers(limit));

        String ext = isExcel ? ".xlsx" : ".pdf";
        String contentType = isExcel
                ? "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                : "application/pdf";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"top-" + limit + "-khach-hang" + ext + "\"")
                .contentType(MediaType.parseMediaType(contentType))
                .body(data);
    }
}
