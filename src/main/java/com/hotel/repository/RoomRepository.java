package com.hotel.repository;

import com.hotel.model.Room;
import java.time.LocalDate;
import java.util.List;

public interface RoomRepository {
    List<Room> findAll();
    List<Room> findAvailable();
    List<Room> findAvailableForDates(LocalDate checkIn, LocalDate checkOut);
    Room findById(Integer id);
    void insert(Room room);
    void update(Room room);
    void updateStatus(Integer roomId, String status);
    void delete(Integer id);
}
