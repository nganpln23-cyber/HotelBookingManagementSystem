package com.hotel.service;

import com.hotel.repository.RoomRepository;
import com.hotel.model.Room;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class RoomService {
    private final RoomRepository roomRepository;

    public RoomService(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    public List<Room> findAll() { return roomRepository.findAll(); }
    public List<Room> findAvailable() { return roomRepository.findAvailable(); }
    public List<Room> findAvailableForDates(LocalDate checkIn, LocalDate checkOut) { return roomRepository.findAvailableForDates(checkIn, checkOut); }
    public Room findById(Integer id) { return roomRepository.findById(id); }
    public void save(Room room) {
        if (room.getId() == null) roomRepository.insert(room);
        else roomRepository.update(room);
    }
    public void updateStatus(Integer roomId, String status) { roomRepository.updateStatus(roomId, status); }
    public void delete(Integer id) { roomRepository.delete(id); }
}
