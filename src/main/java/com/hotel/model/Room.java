package com.hotel.model;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class Room {
    private Integer id;

    @NotBlank(message = "Số phòng không được để trống")
    private String roomNumber;

    @NotNull(message = "Vui lòng chọn loại phòng")
    private Integer roomTypeId;

    @NotNull(message = "Vui lòng nhập tầng")
    @Min(value = 1, message = "Tầng phải lớn hơn 0")
    private Integer floor;

    private String status;
    private String description;
    private RoomType roomType;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public Integer getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(Integer roomTypeId) { this.roomTypeId = roomTypeId; }
    public Integer getFloor() { return floor; }
    public void setFloor(Integer floor) { this.floor = floor; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public RoomType getRoomType() { return roomType; }
    public void setRoomType(RoomType roomType) { this.roomType = roomType; }
}
