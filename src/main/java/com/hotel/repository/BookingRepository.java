package com.hotel.repository;

import com.hotel.model.Booking;
import java.time.LocalDate;
import java.util.List;

public interface BookingRepository {
    List<Booking> findAll();
    Booking findById(Integer id);
    void insert(Booking b);
    List<Booking> findActiveForRange(LocalDate from, LocalDate to);
    boolean hasActiveOverlap(Integer roomId, LocalDate checkInDate, LocalDate checkOutDate);
    boolean hasConfirmedOverlap(Integer roomId, LocalDate checkInDate, LocalDate checkOutDate);
    boolean hasConfirmedOverlap(Integer roomId, LocalDate checkInDate, LocalDate checkOutDate, Integer excludeBookingId);
    void update(Booking b);
    List<Booking> findByCustomerId(Integer customerId);
    int countCompletedByCustomer(Integer customerId);
    void updateStatus(Integer bookingId, String status);
    void delete(Integer id);
}
