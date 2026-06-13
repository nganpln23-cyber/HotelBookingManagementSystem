package com.hotel.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class DailyRevenue {
    private LocalDate date;
    private BigDecimal totalAmount;
    private int paymentCount;

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public int getPaymentCount() { return paymentCount; }
    public void setPaymentCount(int paymentCount) { this.paymentCount = paymentCount; }
}
