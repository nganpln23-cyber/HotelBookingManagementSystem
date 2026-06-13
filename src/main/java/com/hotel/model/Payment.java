package com.hotel.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private Integer id;
    private Integer bookingId;
    private BigDecimal amount;
    private String method;
    private String status;
    private String note;
    private Timestamp paidAt;

    private String customerName;
    private String roomNumber;
    private BigDecimal bookingTotal;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public BigDecimal getBookingTotal() { return bookingTotal; }
    public void setBookingTotal(BigDecimal bookingTotal) { this.bookingTotal = bookingTotal; }
}
