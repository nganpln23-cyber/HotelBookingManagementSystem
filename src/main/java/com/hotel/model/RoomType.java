package com.hotel.model;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class RoomType {
    private Integer id;

    @NotBlank(message = "Tên loại phòng không được để trống")
    private String typeName;

    private String description;

    @NotNull(message = "Giá mỗi đêm không được để trống")
    @DecimalMin(value = "0.01", message = "Giá phải lớn hơn 0")
    private BigDecimal pricePerNight;

    @NotNull(message = "Số khách tối đa không được để trống")
    @Min(value = 1, message = "Số khách tối đa phải ít nhất là 1")
    private Integer maxGuests;

    private String imageUrl;
    private byte[] imageData;
    private String imageContentType;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }
    public Integer getMaxGuests() { return maxGuests; }
    public void setMaxGuests(Integer maxGuests) { this.maxGuests = maxGuests; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public byte[] getImageData() { return imageData; }
    public void setImageData(byte[] imageData) { this.imageData = imageData; }
    public String getImageContentType() { return imageContentType; }
    public void setImageContentType(String imageContentType) { this.imageContentType = imageContentType; }

    /** URL to use in an &lt;img&gt; tag: an uploaded image stored in the DB takes priority over the external image URL. */
    public String getImageDisplayUrl(String contextPath) {
        if (imageContentType != null && !imageContentType.isBlank()) {
            return contextPath + "/room-types/" + id + "/image";
        }
        return imageUrl;
    }
}
