package com.hotel.service;

import com.hotel.dao.RoomTypeDAO;
import com.hotel.model.RoomType;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.List;

@Service
public class RoomTypeService {
    private final RoomTypeDAO roomTypeDAO;

    public RoomTypeService(RoomTypeDAO roomTypeDAO) {
        this.roomTypeDAO = roomTypeDAO;
    }

    public List<RoomType> findAll() { return roomTypeDAO.findAll(); }
    public RoomType findById(Integer id) { return roomTypeDAO.findById(id); }
    public RoomType findImageById(Integer id) { return roomTypeDAO.findImageById(id); }

    public void save(RoomType roomType, MultipartFile imageFile) {
        Integer id = roomType.getId();
        if (id == null) {
            id = roomTypeDAO.insert(roomType);
        } else {
            roomTypeDAO.update(roomType);
        }
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                roomTypeDAO.updateImage(id, imageFile.getBytes(), imageFile.getContentType());
            } catch (IOException e) {
                throw new UncheckedIOException(e);
            }
        }
    }

    public void delete(Integer id) { roomTypeDAO.delete(id); }
}
