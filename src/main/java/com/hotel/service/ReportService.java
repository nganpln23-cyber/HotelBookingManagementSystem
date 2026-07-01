package com.hotel.service;

import com.hotel.model.MonthlyRevenue;
import com.hotel.model.OccupancyData;
import com.hotel.model.QuarterlyRevenue;
import com.hotel.model.RevenueReport;
import com.hotel.model.TopCustomer;
import com.hotel.model.YearlyRevenue;
import com.hotel.repository.PaymentRepository;
import com.hotel.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

@Service
public class ReportService {
    private final PaymentRepository paymentRepository;
    private final RoomRepository roomRepository;

    public ReportService(PaymentRepository paymentRepository, RoomRepository roomRepository) {
        this.paymentRepository = paymentRepository;
        this.roomRepository = roomRepository;
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

    public List<MonthlyRevenue> getMonthlyReport(int year) {
        return paymentRepository.getMonthlyRevenue(year);
    }

    public List<YearlyRevenue> getYearlyReport() {
        return paymentRepository.getYearlyRevenue();
    }

    public List<QuarterlyRevenue> getQuarterlyReport(int year) {
        return paymentRepository.getQuarterlyRevenue(year);
    }

    public List<TopCustomer> getTopCustomers(int limit) {
        return paymentRepository.getTopCustomers(limit);
    }

    public List<OccupancyData> getMonthlyOccupancy(int year) {
        int totalRooms = roomRepository.countTotalActiveRooms();
        return paymentRepository.getMonthlyOccupancy(year, totalRooms);
    }

    public List<OccupancyData> getQuarterlyOccupancy(int year) {
        int totalRooms = roomRepository.countTotalActiveRooms();
        return paymentRepository.getQuarterlyOccupancy(year, totalRooms);
    }

    public List<OccupancyData> getYearlyOccupancy() {
        int totalRooms = roomRepository.countTotalActiveRooms();
        return paymentRepository.getYearlyOccupancy(totalRooms);
    }
}
