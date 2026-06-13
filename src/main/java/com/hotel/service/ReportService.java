package com.hotel.service;

import com.hotel.dao.PaymentDAO;
import com.hotel.model.RevenueReport;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDate;

@Service
public class ReportService {
    private final PaymentDAO paymentDAO;

    public ReportService(PaymentDAO paymentDAO) {
        this.paymentDAO = paymentDAO;
    }

    public RevenueReport getRevenueReport(LocalDate from, LocalDate to) {
        Timestamp fromTs = Timestamp.valueOf(from.atStartOfDay());
        Timestamp toTs = Timestamp.valueOf(to.plusDays(1).atStartOfDay());

        RevenueReport report = new RevenueReport();
        report.setFrom(from);
        report.setTo(to);
        report.setTotalRevenue(paymentDAO.getRevenueTotal(fromTs, toTs));
        report.setPaymentCount(paymentDAO.getPaymentCount(fromTs, toTs));
        report.setDailyRevenue(paymentDAO.getDailyRevenue(fromTs, toTs));
        report.setRoomTypeRevenue(paymentDAO.getRevenueByRoomType(fromTs, toTs));
        return report;
    }
}
