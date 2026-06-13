package com.hotel.dao;

import com.hotel.model.DailyRevenue;
import com.hotel.model.Payment;
import com.hotel.model.RoomTypeRevenue;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

@Repository
public class PaymentDAO {
    private final JdbcTemplate jdbcTemplate;

    public PaymentDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Payment> mapper = (rs, rowNum) -> {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setMethod(rs.getString("method"));
        p.setStatus(rs.getString("status"));
        p.setNote(rs.getString("note"));
        p.setPaidAt(rs.getTimestamp("paid_at"));
        try { p.setCustomerName(rs.getString("customer_name")); } catch (Exception ignored) {}
        try { p.setRoomNumber(rs.getString("room_number")); } catch (Exception ignored) {}
        try { p.setBookingTotal(rs.getBigDecimal("total_amount")); } catch (Exception ignored) {}
        return p;
    };

    public void insert(Payment p) {
        String sql = "INSERT INTO payments(booking_id, amount, method, status, note) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, p.getBookingId(), p.getAmount(), p.getMethod(), p.getStatus(), p.getNote());
    }

    public List<Payment> findAll() {
        String sql = "SELECT p.*, c.full_name AS customer_name, r.room_number, b.total_amount " +
                "FROM payments p " +
                "JOIN bookings b ON p.booking_id = b.id " +
                "JOIN customers c ON b.customer_id = c.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "ORDER BY p.paid_at DESC";
        return jdbcTemplate.query(sql, mapper);
    }

    public List<Payment> findByBookingId(Integer bookingId) {
        String sql = "SELECT p.*, c.full_name AS customer_name, r.room_number, b.total_amount " +
                "FROM payments p " +
                "JOIN bookings b ON p.booking_id = b.id " +
                "JOIN customers c ON b.customer_id = c.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "WHERE p.booking_id=? ORDER BY p.paid_at DESC";
        return jdbcTemplate.query(sql, mapper, bookingId);
    }

    public BigDecimal sumPaidByBooking(Integer bookingId) {
        String sql = "SELECT COALESCE(SUM(amount),0) FROM payments WHERE booking_id=? AND status='PAID'";
        return jdbcTemplate.queryForObject(sql, BigDecimal.class, bookingId);
    }

    public BigDecimal getRevenueTotal(Timestamp from, Timestamp to) {
        String sql = "SELECT COALESCE(SUM(amount),0) FROM payments WHERE status='PAID' AND paid_at >= ? AND paid_at < ?";
        return jdbcTemplate.queryForObject(sql, BigDecimal.class, from, to);
    }

    public int getPaymentCount(Timestamp from, Timestamp to) {
        String sql = "SELECT COUNT(*) FROM payments WHERE status='PAID' AND paid_at >= ? AND paid_at < ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, from, to);
    }

    public List<DailyRevenue> getDailyRevenue(Timestamp from, Timestamp to) {
        String sql = "SELECT DATE(paid_at) AS rev_date, SUM(amount) AS total_amount, COUNT(*) AS payment_count " +
                "FROM payments WHERE status='PAID' AND paid_at >= ? AND paid_at < ? " +
                "GROUP BY DATE(paid_at) ORDER BY rev_date";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            DailyRevenue d = new DailyRevenue();
            d.setDate(rs.getDate("rev_date").toLocalDate());
            d.setTotalAmount(rs.getBigDecimal("total_amount"));
            d.setPaymentCount(rs.getInt("payment_count"));
            return d;
        }, from, to);
    }

    public List<RoomTypeRevenue> getRevenueByRoomType(Timestamp from, Timestamp to) {
        String sql = "SELECT rt.type_name, SUM(p.amount) AS total_amount, COUNT(DISTINCT p.booking_id) AS booking_count " +
                "FROM payments p " +
                "JOIN bookings b ON p.booking_id = b.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "JOIN room_types rt ON r.room_type_id = rt.id " +
                "WHERE p.status='PAID' AND p.paid_at >= ? AND p.paid_at < ? " +
                "GROUP BY rt.type_name ORDER BY total_amount DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            RoomTypeRevenue r = new RoomTypeRevenue();
            r.setTypeName(rs.getString("type_name"));
            r.setTotalAmount(rs.getBigDecimal("total_amount"));
            r.setBookingCount(rs.getInt("booking_count"));
            return r;
        }, from, to);
    }
}
