package com.hotel.model;

import jakarta.validation.constraints.NotNull;
import org.springframework.format.annotation.DateTimeFormat;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;

public class Booking {
    private Integer id;
    private Integer customerId;

    @NotNull(message = "Vui lòng chọn phòng")
    private Integer roomId;

    @NotNull(message = "Vui lòng chọn ngày nhận phòng")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate checkInDate;

    @NotNull(message = "Vui lòng chọn ngày trả phòng")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate checkOutDate;

    private String status;
    private BigDecimal totalAmount;
    private String note;
    private Timestamp createdAt;
    private String promoCode;
    private BigDecimal discountAmount;

    private String customerName;
    private String roomNumber;
    private String roomTypeName;
    private String confirmationCode;
    private String checkinCode;
    private boolean onlinePaid;
    private String onlinePaymentRef;
    private String customerEmail;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
    public Integer getRoomId() { return roomId; }
    public void setRoomId(Integer roomId) { this.roomId = roomId; }
    public LocalDate getCheckInDate() { return checkInDate; }
    public void setCheckInDate(LocalDate checkInDate) { this.checkInDate = checkInDate; }
    public LocalDate getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(LocalDate checkOutDate) { this.checkOutDate = checkOutDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }
    public String getPromoCode() { return promoCode; }
    public void setPromoCode(String promoCode) { this.promoCode = promoCode; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
    public String getConfirmationCode() { return confirmationCode; }
    public void setConfirmationCode(String confirmationCode) { this.confirmationCode = confirmationCode; }
    public String getCheckinCode() { return checkinCode; }
    public void setCheckinCode(String checkinCode) { this.checkinCode = checkinCode; }
    public boolean isOnlinePaid() { return onlinePaid; }
    public void setOnlinePaid(boolean onlinePaid) { this.onlinePaid = onlinePaid; }
    public String getOnlinePaymentRef() { return onlinePaymentRef; }
    public void setOnlinePaymentRef(String onlinePaymentRef) { this.onlinePaymentRef = onlinePaymentRef; }
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
}
