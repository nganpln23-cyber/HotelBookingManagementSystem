package com.hotel.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class RevenueReport {
    private LocalDate from;
    private LocalDate to;
    private BigDecimal totalRevenue;
    private int paymentCount;
    private List<DailyRevenue> dailyRevenue;
    private List<RoomTypeRevenue> roomTypeRevenue;

    public LocalDate getFrom() { return from; }
    public void setFrom(LocalDate from) { this.from = from; }
    public LocalDate getTo() { return to; }
    public void setTo(LocalDate to) { this.to = to; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    public int getPaymentCount() { return paymentCount; }
    public void setPaymentCount(int paymentCount) { this.paymentCount = paymentCount; }
    public List<DailyRevenue> getDailyRevenue() { return dailyRevenue; }
    public void setDailyRevenue(List<DailyRevenue> dailyRevenue) { this.dailyRevenue = dailyRevenue; }
    public List<RoomTypeRevenue> getRoomTypeRevenue() { return roomTypeRevenue; }
    public void setRoomTypeRevenue(List<RoomTypeRevenue> roomTypeRevenue) { this.roomTypeRevenue = roomTypeRevenue; }
}
