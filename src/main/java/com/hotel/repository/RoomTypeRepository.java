package com.hotel.repository;

import com.hotel.model.RoomType;
import java.util.List;

public interface RoomTypeRepository {
    List<RoomType> findAll();
    RoomType findById(Integer id);
    Integer insert(RoomType roomType);
    void update(RoomType roomType);
    void updateImage(Integer id, byte[] imageData, String imageContentType);
    RoomType findImageById(Integer id);
    void delete(Integer id);
}
