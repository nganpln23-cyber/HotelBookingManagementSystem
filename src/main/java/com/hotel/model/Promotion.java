package com.hotel.model;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class Promotion {
    private Integer id;

    @NotBlank(message = "Mã khuyến mãi không được để trống")
    private String code;

    private String description;

    @NotNull(message = "Phần trăm giảm giá không được để trống")
    @DecimalMin(value = "0.01", message = "Giảm giá phải lớn hơn 0%")
    @DecimalMax(value = "100", message = "Giảm giá không được vượt quá 100%")
    private BigDecimal discountPercent;

    @Min(value = 0, message = "Số booking tối thiểu phải >= 0")
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
