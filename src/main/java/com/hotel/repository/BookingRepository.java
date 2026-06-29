package com.hotel.repository;

import com.hotel.model.Booking;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.List;

@Repository
public class BookingRepository {
    private final JdbcTemplate jdbcTemplate;

    public BookingRepository(JdbcTemplate jdbcTemplate) {
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
        try { b.setConfirmationCode(rs.getString("confirmation_code")); } catch (Exception ignored) {}
        try { b.setCheckinCode(rs.getString("checkin_code")); } catch (Exception ignored) {}
        try { b.setOnlinePaid(rs.getBoolean("is_online_paid")); } catch (Exception ignored) {}
        try { b.setOnlinePaymentRef(rs.getString("online_payment_ref")); } catch (Exception ignored) {}
        try { b.setCustomerEmail(rs.getString("customer_email")); } catch (Exception ignored) {}
        return b;
    };

    private static final String JOIN_SQL =
            "SELECT b.*, c.full_name AS customer_name, c.email AS customer_email, r.room_number, rt.type_name " +
            "FROM bookings b " +
            "JOIN customers c ON b.customer_id = c.id " +
            "JOIN rooms r ON b.room_id = r.id " +
            "JOIN room_types rt ON r.room_type_id = rt.id ";

    public List<Booking> findAll() {
        return jdbcTemplate.query(JOIN_SQL + "ORDER BY b.id ASC", mapper);
    }

    public Booking findById(Integer id) {
        return jdbcTemplate.queryForObject(JOIN_SQL + "WHERE b.id=?", mapper, id);
    }

    public int insert(Booking b) {
        BigDecimal discount = b.getDiscountAmount() != null ? b.getDiscountAmount() : BigDecimal.ZERO;
        KeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(conn -> {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO bookings(customer_id, room_id, check_in_date, check_out_date, status, total_amount, note, promo_code, discount_amount, is_online_paid, online_payment_ref, customer_email) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, b.getCustomerId());
            ps.setInt(2, b.getRoomId());
            ps.setDate(3, Date.valueOf(b.getCheckInDate()));
            ps.setDate(4, Date.valueOf(b.getCheckOutDate()));
            ps.setString(5, b.getStatus());
            ps.setBigDecimal(6, b.getTotalAmount());
            ps.setString(7, b.getNote());
            ps.setString(8, b.getPromoCode());
            ps.setBigDecimal(9, discount);
            ps.setBoolean(10, b.isOnlinePaid());
            ps.setString(11, b.getOnlinePaymentRef());
            ps.setString(12, b.getCustomerEmail());
            return ps;
        }, kh);
        int id = kh.getKey().intValue();
        b.setId(id);
        return id;
    }

    public void update(Booking b) {
        jdbcTemplate.update(
            "UPDATE bookings SET customer_id=?, room_id=?, check_in_date=?, check_out_date=?, status=?, total_amount=?, note=? WHERE id=?",
            b.getCustomerId(), b.getRoomId(), Date.valueOf(b.getCheckInDate()), Date.valueOf(b.getCheckOutDate()),
            b.getStatus(), b.getTotalAmount(), b.getNote(), b.getId());
    }

    public void updateStatus(Integer id, String status) {
        jdbcTemplate.update("UPDATE bookings SET status=? WHERE id=?", status, id);
    }

    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM bookings WHERE id=?", id);
    }

    public List<Booking> findByCustomerId(Integer customerId) {
        return jdbcTemplate.query(JOIN_SQL + "WHERE b.customer_id=? ORDER BY b.id ASC", mapper, customerId);
    }

    public List<Booking> findActiveForRange(LocalDate from, LocalDate to) {
        return jdbcTemplate.query(
            "SELECT * FROM bookings WHERE status IN ('AWAITING_PAYMENT','PENDING','CONFIRMED','CHECKED_IN') AND check_in_date < ? AND check_out_date > ?",
            mapper, Date.valueOf(to), Date.valueOf(from));
    }

    public boolean hasActiveOverlap(Integer roomId, LocalDate checkIn, LocalDate checkOut) {
        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM bookings WHERE room_id=? AND status IN ('PENDING','CONFIRMED','CHECKED_IN') AND check_in_date < ? AND check_out_date > ?",
            Integer.class, roomId, Date.valueOf(checkOut), Date.valueOf(checkIn));
        return count != null && count > 0;
    }

    public boolean hasConfirmedOverlap(Integer roomId, LocalDate checkIn, LocalDate checkOut) {
        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM bookings WHERE room_id=? AND status IN ('CONFIRMED','CHECKED_IN') AND check_in_date < ? AND check_out_date > ?",
            Integer.class, roomId, Date.valueOf(checkOut), Date.valueOf(checkIn));
        return count != null && count > 0;
    }

    public boolean hasConfirmedOverlap(Integer roomId, LocalDate checkIn, LocalDate checkOut, Integer excludeId) {
        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM bookings WHERE room_id=? AND status IN ('CONFIRMED','CHECKED_IN') AND check_in_date < ? AND check_out_date > ? AND id != ?",
            Integer.class, roomId, Date.valueOf(checkOut), Date.valueOf(checkIn), excludeId);
        return count != null && count > 0;
    }

    public void updateOnlinePayment(Integer id, String paymentRef) {
        jdbcTemplate.update("UPDATE bookings SET is_online_paid=1, online_payment_ref=? WHERE id=?", paymentRef, id);
    }

    public void updateConfirmationCode(Integer id, String code) {
        jdbcTemplate.update("UPDATE bookings SET confirmation_code=? WHERE id=?", code, id);
    }

    public void updateCheckinCode(Integer id, String code) {
        jdbcTemplate.update("UPDATE bookings SET checkin_code=? WHERE id=?", code, id);
    }

    public List<Booking> findByStatuses(String... statuses) {
        String placeholders = String.join(",", java.util.Collections.nCopies(statuses.length, "?"));
        return jdbcTemplate.query(JOIN_SQL + "WHERE b.status IN (" + placeholders + ") ORDER BY b.check_in_date ASC", mapper, (Object[]) statuses);
    }

    public int countCompletedByCustomer(Integer customerId) {
        Integer c = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM bookings WHERE customer_id=? AND status='CHECKED_OUT'", Integer.class, customerId);
        return c == null ? 0 : c;
    }

    /**
     * Determines the correct room status based on remaining active bookings.
     * Priority: CHECKED_IN → OCCUPIED, CONFIRMED → BOOKED, else AVAILABLE.
     */
    public String findDominantBookingStatusForRoom(Integer roomId) {
        Integer checkedIn = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM bookings WHERE room_id=? AND status='CHECKED_IN'",
            Integer.class, roomId);
        if (checkedIn != null && checkedIn > 0) return "OCCUPIED";

        Integer confirmed = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM bookings WHERE room_id=? AND status='CONFIRMED'",
            Integer.class, roomId);
        if (confirmed != null && confirmed > 0) return "BOOKED";

        return "AVAILABLE";
    }
}
