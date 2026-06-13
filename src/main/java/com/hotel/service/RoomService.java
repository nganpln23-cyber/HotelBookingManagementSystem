package com.hotel.service;

import com.hotel.dao.RoomDAO;
import com.hotel.model.Room;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class RoomService {
    private final RoomDAO roomDAO;

    public RoomService(RoomDAO roomDAO) {
        this.roomDAO = roomDAO;
    }

    public List<Room> findAll() { return roomDAO.findAll(); }
    public List<Room> findAvailable() { return roomDAO.findAvailable(); }
    public List<Room> findAvailableForDates(LocalDate checkIn, LocalDate checkOut) { return roomDAO.findAvailableForDates(checkIn, checkOut); }
    public Room findById(Integer id) { return roomDAO.findById(id); }
    public void save(Room room) {
        if (room.getId() == null) roomDAO.insert(room);
        else roomDAO.update(room);
    }
    public void updateStatus(Integer roomId, String status) { roomDAO.updateStatus(roomId, status); }
    public void delete(Integer id) { roomDAO.delete(id); }
}
