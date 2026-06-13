package com.hotel.service;

import com.hotel.repository.RoomTypeRepository;
import com.hotel.model.RoomType;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.List;

@Service
public class RoomTypeService {
    private final RoomTypeRepository roomTypeRepository;

    public RoomTypeService(RoomTypeRepository roomTypeRepository) {
        this.roomTypeRepository = roomTypeRepository;
    }

    public List<RoomType> findAll() { return roomTypeRepository.findAll(); }
    public RoomType findById(Integer id) { return roomTypeRepository.findById(id); }
    public RoomType findImageById(Integer id) { return roomTypeRepository.findImageById(id); }

    public void save(RoomType roomType, MultipartFile imageFile) {
        Integer id = roomType.getId();
        if (id == null) {
            id = roomTypeRepository.insert(roomType);
        } else {
            roomTypeRepository.update(roomType);
        }
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                roomTypeRepository.updateImage(id, imageFile.getBytes(), imageFile.getContentType());
            } catch (IOException e) {
                throw new UncheckedIOException(e);
            }
        }
    }

    public void delete(Integer id) { roomTypeRepository.delete(id); }
}
