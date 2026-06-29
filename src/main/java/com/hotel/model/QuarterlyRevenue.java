package com.hotel.model;

import java.math.BigDecimal;

public class QuarterlyRevenue {
    private int year;
    private int quarter;
    private BigDecimal totalAmount;
    private int paymentCount;

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }
    public int getQuarter() { return quarter; }
    public void setQuarter(int quarter) { this.quarter = quarter; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public int getPaymentCount() { return paymentCount; }
    public void setPaymentCount(int paymentCount) { this.paymentCount = paymentCount; }

    public String getQuarterLabel() {
        return "Q" + quarter + " / " + year;
    }
}
