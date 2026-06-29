package com.hotel.model;

import java.math.BigDecimal;

public class YearlyRevenue {
    private int year;
    private BigDecimal totalAmount;
    private int paymentCount;

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public int getPaymentCount() { return paymentCount; }
    public void setPaymentCount(int paymentCount) { this.paymentCount = paymentCount; }
}
