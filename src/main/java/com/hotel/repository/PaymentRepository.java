package com.hotel.repository;

import com.hotel.model.DailyRevenue;
import com.hotel.model.Payment;
import com.hotel.model.RoomTypeRevenue;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public interface PaymentRepository {
    void insert(Payment p);
    void deleteByBookingId(Integer bookingId);
    List<Payment> findAll();
    List<Payment> findByBookingId(Integer bookingId);
    BigDecimal sumPaidByBooking(Integer bookingId);
    BigDecimal getRevenueTotal(Timestamp from, Timestamp to);
    int getPaymentCount(Timestamp from, Timestamp to);
    List<DailyRevenue> getDailyRevenue(Timestamp from, Timestamp to);
    List<RoomTypeRevenue> getRevenueByRoomType(Timestamp from, Timestamp to);
}
