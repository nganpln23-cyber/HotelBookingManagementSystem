package com.hotel.dao;

import com.hotel.model.DashboardStats;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;

@Repository
public class DashboardDAO {
    private final JdbcTemplate jdbcTemplate;

    public DashboardDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public DashboardStats getStats() {
        DashboardStats s = new DashboardStats();
        s.setTotalRooms(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM rooms", Integer.class));
        s.setAvailableRooms(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM rooms WHERE status='AVAILABLE'", Integer.class));
        s.setTotalCustomers(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM customers", Integer.class));
        s.setTotalBookings(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM bookings", Integer.class));
        BigDecimal revenue = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(total_amount),0) FROM bookings WHERE status IN ('CONFIRMED','CHECKED_IN','CHECKED_OUT')",
                BigDecimal.class
        );
        s.setTotalRevenue(revenue);
        return s;
    }
}
