package com.hotel.model;

import java.math.BigDecimal;

public class TopCustomer {
    private int id;
    private String fullName;
    private String phone;
    private String email;
    private int bookingCount;
    private BigDecimal totalSpent;
    private String lastBookingDate;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public int getBookingCount() { return bookingCount; }
    public void setBookingCount(int bookingCount) { this.bookingCount = bookingCount; }
    public BigDecimal getTotalSpent() { return totalSpent; }
    public void setTotalSpent(BigDecimal totalSpent) { this.totalSpent = totalSpent; }
    public String getLastBookingDate() { return lastBookingDate; }
    public void setLastBookingDate(String lastBookingDate) { this.lastBookingDate = lastBookingDate; }
}
