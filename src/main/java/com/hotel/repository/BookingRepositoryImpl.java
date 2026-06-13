package com.hotel.repository;

import com.hotel.model.Booking;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@Component
public class BookingRepositoryImpl implements BookingRepository {
    private final JdbcTemplate jdbcTemplate;

    public BookingRepositoryImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Booking> mapper = (rs, rowNum) -> {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setCustomerId(rs.getInt("customer_id"));
        b.setRoomId(rs.getInt("room_id"));
        b.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        b.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        b.setStatus(rs.getString("status"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setNote(rs.getString("note"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setPromoCode(rs.getString("promo_code"));
        b.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        try { b.setCustomerName(rs.getString("customer_name")); } catch (Exception ignored) {}
        try { b.setRoomNumber(rs.getString("room_number")); } catch (Exception ignored) {}
        try { b.setRoomTypeName(rs.getString("type_name")); } catch (Exception ignored) {}
        return b;
    };

    @Override
    public List<Booking> findAll() {
        String sql = "SELECT b.*, c.full_name AS customer_name, r.room_number, rt.type_name " +
                "FROM bookings b " +
                "JOIN customers c ON b.customer_id = c.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "JOIN room_types rt ON r.room_type_id = rt.id " +
                "ORDER BY b.id DESC";
        return jdbcTemplate.query(sql, mapper);
    }

    @Override
    public Booking findById(Integer id) {
        String sql = "SELECT b.*, c.full_name AS customer_name, r.room_number, rt.type_name " +
                "FROM bookings b " +
                "JOIN customers c ON b.customer_id = c.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "JOIN room_types rt ON r.room_type_id = rt.id " +
                "WHERE b.id=?";
        return jdbcTemplate.queryForObject(sql, mapper, id);
    }

    @Override
    public void insert(Booking b) {
        String sql = "INSERT INTO bookings(customer_id, room_id, check_in_date, check_out_date, status, total_amount, note, promo_code, discount_amount) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        BigDecimal discountAmount = b.getDiscountAmount() != null ? b.getDiscountAmount() : BigDecimal.ZERO;
        jdbcTemplate.update(sql, b.getCustomerId(), b.getRoomId(), Date.valueOf(b.getCheckInDate()),
                Date.valueOf(b.getCheckOutDate()), b.getStatus(), b.getTotalAmount(), b.getNote(),
                b.getPromoCode(), discountAmount);
    }

    @Override
    public List<Booking> findActiveForRange(LocalDate from, LocalDate to) {
        String sql = "SELECT * FROM bookings WHERE status IN ('PENDING','CONFIRMED','CHECKED_IN') " +
                "AND check_in_date < ? AND check_out_date > ?";
        return jdbcTemplate.query(sql, mapper, Date.valueOf(to), Date.valueOf(from));
    }

    @Override
    public boolean hasActiveOverlap(Integer roomId, LocalDate checkInDate, LocalDate checkOutDate) {
        String sql = "SELECT COUNT(*) FROM bookings " +
                "WHERE room_id=? " +
                "AND status IN ('PENDING', 'CONFIRMED', 'CHECKED_IN') " +
                "AND check_in_date < ? " +
                "AND check_out_date > ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, roomId,
                Date.valueOf(checkOutDate), Date.valueOf(checkInDate));
        return count != null && count > 0;
    }

    @Override
    public void update(Booking b) {
        String sql = "UPDATE bookings SET customer_id=?, room_id=?, check_in_date=?, check_out_date=?, status=?, total_amount=?, note=? WHERE id=?";
        jdbcTemplate.update(sql, b.getCustomerId(), b.getRoomId(), Date.valueOf(b.getCheckInDate()),
                Date.valueOf(b.getCheckOutDate()), b.getStatus(), b.getTotalAmount(), b.getNote(), b.getId());
    }

    @Override
    public List<Booking> findByCustomerId(Integer customerId) {
        String sql = "SELECT b.*, c.full_name AS customer_name, r.room_number, rt.type_name " +
                "FROM bookings b " +
                "JOIN customers c ON b.customer_id = c.id " +
                "JOIN rooms r ON b.room_id = r.id " +
                "JOIN room_types rt ON r.room_type_id = rt.id " +
                "WHERE b.customer_id=? ORDER BY b.id DESC";
        return jdbcTemplate.query(sql, mapper, customerId);
    }

    @Override
    public int countCompletedByCustomer(Integer customerId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM bookings WHERE customer_id=? AND status='CHECKED_OUT'", Integer.class, customerId);
        return count == null ? 0 : count;
    }

    @Override
    public void updateStatus(Integer bookingId, String status) {
        jdbcTemplate.update("UPDATE bookings SET status=? WHERE id=?", status, bookingId);
    }

    @Override
    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM bookings WHERE id=?", id);
    }
}
