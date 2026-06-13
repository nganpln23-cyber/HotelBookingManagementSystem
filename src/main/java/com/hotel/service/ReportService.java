package com.hotel.service;

import com.hotel.repository.PaymentRepository;
import com.hotel.model.RevenueReport;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDate;

@Service
public class ReportService {
    private final PaymentRepository paymentRepository;

    public ReportService(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    public RevenueReport getRevenueReport(LocalDate from, LocalDate to) {
        Timestamp fromTs = Timestamp.valueOf(from.atStartOfDay());
        Timestamp toTs = Timestamp.valueOf(to.plusDays(1).atStartOfDay());

        RevenueReport report = new RevenueReport();
        report.setFrom(from);
        report.setTo(to);
        report.setTotalRevenue(paymentRepository.getRevenueTotal(fromTs, toTs));
        report.setPaymentCount(paymentRepository.getPaymentCount(fromTs, toTs));
        report.setDailyRevenue(paymentRepository.getDailyRevenue(fromTs, toTs));
        report.setRoomTypeRevenue(paymentRepository.getRevenueByRoomType(fromTs, toTs));
        return report;
    }
}
