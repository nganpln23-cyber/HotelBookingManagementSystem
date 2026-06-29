package com.hotel.repository;

import com.hotel.model.Booking;
import com.hotel.model.DashboardStats;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class DashboardRepository {
    private final JdbcTemplate jdbcTemplate;

    public DashboardRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private Booking mapBooking(ResultSet rs, int rowNum) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setStatus(rs.getString("status"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        b.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        try { b.setCustomerName(rs.getString("customer_name")); } catch (Exception ignored) {}
        try { b.setRoomNumber(rs.getString("room_number")); } catch (Exception ignored) {}
        try { b.setRoomTypeName(rs.getString("type_name")); } catch (Exception ignored) {}
        return b;
    }

    public DashboardStats getStats() {
        DashboardStats s = new DashboardStats();
        s.setTotalRooms(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM rooms", Integer.class));
        s.setAvailableRooms(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM rooms WHERE status='AVAILABLE'", Integer.class));
        s.setOccupiedRooms(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM rooms WHERE status='OCCUPIED'", Integer.class));
        s.setBookedRooms(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM rooms WHERE status='BOOKED'", Integer.class));
        s.setMaintenanceRooms(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM rooms WHERE status='MAINTENANCE'", Integer.class));
        s.setTotalCustomers(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM customers", Integer.class));
        s.setTotalBookings(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM bookings", Integer.class));
        s.setPendingBookings(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM bookings WHERE status='PENDING'", Integer.class));
        s.setCheckedInCount(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM bookings WHERE status='CHECKED_IN'", Integer.class));
        BigDecimal revenue = jdbcTemplate.queryForObject(
            "SELECT COALESCE(SUM(total_amount),0) FROM bookings WHERE status IN ('CONFIRMED','CHECKED_IN','CHECKED_OUT')",
            BigDecimal.class);
        s.setTotalRevenue(revenue);
        s.setRecentBookings(jdbcTemplate.query(
            "SELECT b.id, b.status, b.total_amount, b.check_in_date, b.check_out_date, " +
            "c.full_name AS customer_name, r.room_number, rt.type_name " +
            "FROM bookings b " +
            "JOIN customers c ON b.customer_id = c.id " +
            "JOIN rooms r ON b.room_id = r.id " +
            "JOIN room_types rt ON r.room_type_id = rt.id " +
            "ORDER BY b.id DESC LIMIT 8",
            this::mapBooking));
        return s;
    }
}
