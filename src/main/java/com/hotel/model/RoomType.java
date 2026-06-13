package com.hotel.model;

import java.math.BigDecimal;

public class RoomType {
    private Integer id;
    private String typeName;
    private String description;
    private BigDecimal pricePerNight;
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
