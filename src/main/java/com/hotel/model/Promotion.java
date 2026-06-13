package com.hotel.model;

import java.math.BigDecimal;

public class Promotion {
    private Integer id;
    private String code;
    private String description;
    private BigDecimal discountPercent;
    private int minCompletedBookings;
    private boolean active;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(BigDecimal discountPercent) { this.discountPercent = discountPercent; }
    public int getMinCompletedBookings() { return minCompletedBookings; }
    public void setMinCompletedBookings(int minCompletedBookings) { this.minCompletedBookings = minCompletedBookings; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
