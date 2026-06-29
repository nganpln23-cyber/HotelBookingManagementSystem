package com.hotel.repository;

import com.hotel.model.DailyRevenue;
import com.hotel.model.MonthlyRevenue;
import com.hotel.model.Payment;
import com.hotel.model.QuarterlyRevenue;
import com.hotel.model.RoomTypeRevenue;
import com.hotel.model.TopCustomer;
import com.hotel.model.YearlyRevenue;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

@Repository
public class PaymentRepository {
    private final JdbcTemplate jdbcTemplate;

    public PaymentRepository(JdbcTemplate jdbcTemplate) {
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

    private static final String JOIN_SQL =
            "SELECT p.*, c.full_name AS customer_name, r.room_number, b.total_amount " +
            "FROM payments p " +
            "JOIN bookings b ON p.booking_id = b.id " +
            "JOIN customers c ON b.customer_id = c.id " +
            "JOIN rooms r ON b.room_id = r.id ";

    public void insert(Payment p) {
        jdbcTemplate.update(
            "INSERT INTO payments(booking_id, amount, method, status, note) VALUES (?,?,?,?,?)",
            p.getBookingId(), p.getAmount(), p.getMethod(), p.getStatus(), p.getNote());
    }

    public void deleteByBookingId(Integer bookingId) {
        jdbcTemplate.update("DELETE FROM payments WHERE booking_id=?", bookingId);
    }

    public List<Payment> findAll() {
        return jdbcTemplate.query(JOIN_SQL + "ORDER BY p.id ASC", mapper);
    }

    public List<Payment> findByBookingId(Integer bookingId) {
        return jdbcTemplate.query(JOIN_SQL + "WHERE p.booking_id=? ORDER BY p.paid_at DESC", mapper, bookingId);
    }

    public BigDecimal sumPaidByBooking(Integer bookingId) {
        return jdbcTemplate.queryForObject(
            "SELECT COALESCE(SUM(amount),0) FROM payments WHERE booking_id=? AND status='PAID'",
            BigDecimal.class, bookingId);
    }

    public BigDecimal getRevenueTotal(Timestamp from, Timestamp to) {
        return jdbcTemplate.queryForObject(
            "SELECT COALESCE(SUM(amount),0) FROM payments WHERE status='PAID' AND paid_at >= ? AND paid_at < ?",
            BigDecimal.class, from, to);
    }

    public int getPaymentCount(Timestamp from, Timestamp to) {
        return jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM payments WHERE status='PAID' AND paid_at >= ? AND paid_at < ?",
            Integer.class, from, to);
    }

    public List<DailyRevenue> getDailyRevenue(Timestamp from, Timestamp to) {
        return jdbcTemplate.query(
            "SELECT DATE(paid_at) AS rev_date, SUM(amount) AS total_amount, COUNT(*) AS payment_count " +
            "FROM payments WHERE status='PAID' AND paid_at >= ? AND paid_at < ? " +
            "GROUP BY DATE(paid_at) ORDER BY rev_date",
            (rs, rowNum) -> {
                DailyRevenue d = new DailyRevenue();
                d.setDate(rs.getDate("rev_date").toLocalDate());
                d.setTotalAmount(rs.getBigDecimal("total_amount"));
                d.setPaymentCount(rs.getInt("payment_count"));
                return d;
            }, from, to);
    }

    public List<MonthlyRevenue> getMonthlyRevenue(int year) {
        return jdbcTemplate.query(
            "SELECT YEAR(paid_at) AS yr, MONTH(paid_at) AS mo, SUM(amount) AS total_amount, COUNT(*) AS payment_count " +
            "FROM payments WHERE status='PAID' AND YEAR(paid_at)=? " +
            "GROUP BY YEAR(paid_at), MONTH(paid_at) ORDER BY mo",
            (rs, rowNum) -> {
                MonthlyRevenue m = new MonthlyRevenue();
                m.setYear(rs.getInt("yr"));
                m.setMonth(rs.getInt("mo"));
                m.setTotalAmount(rs.getBigDecimal("total_amount"));
                m.setPaymentCount(rs.getInt("payment_count"));
                return m;
            }, year);
    }

    public List<YearlyRevenue> getYearlyRevenue() {
        return jdbcTemplate.query(
            "SELECT YEAR(paid_at) AS yr, SUM(amount) AS total_amount, COUNT(*) AS payment_count " +
            "FROM payments WHERE status='PAID' " +
            "GROUP BY YEAR(paid_at) ORDER BY yr",
            (rs, rowNum) -> {
                YearlyRevenue y = new YearlyRevenue();
                y.setYear(rs.getInt("yr"));
                y.setTotalAmount(rs.getBigDecimal("total_amount"));
                y.setPaymentCount(rs.getInt("payment_count"));
                return y;
            });
    }

    public List<QuarterlyRevenue> getQuarterlyRevenue(int year) {
        return jdbcTemplate.query(
            "SELECT YEAR(paid_at) AS yr, QUARTER(paid_at) AS qtr, " +
            "SUM(amount) AS total_amount, COUNT(*) AS payment_count " +
            "FROM payments WHERE status='PAID' AND YEAR(paid_at)=? " +
            "GROUP BY YEAR(paid_at), QUARTER(paid_at) ORDER BY qtr",
            (rs, rowNum) -> {
                QuarterlyRevenue q = new QuarterlyRevenue();
                q.setYear(rs.getInt("yr"));
                q.setQuarter(rs.getInt("qtr"));
                q.setTotalAmount(rs.getBigDecimal("total_amount"));
                q.setPaymentCount(rs.getInt("payment_count"));
                return q;
            }, year);
    }

    public List<TopCustomer> getTopCustomers(int limit) {
        return jdbcTemplate.query(
            "SELECT c.id, c.full_name, c.phone, c.email, " +
            "COUNT(b.id) AS booking_count, " +
            "COALESCE(SUM(p.amount),0) AS total_spent, " +
            "MAX(DATE(b.created_at)) AS last_booking " +
            "FROM customers c " +
            "JOIN bookings b ON c.id = b.customer_id " +
            "LEFT JOIN payments p ON p.booking_id = b.id AND p.status='PAID' " +
            "WHERE b.status IN ('CONFIRMED','CHECKED_IN','CHECKED_OUT') " +
            "GROUP BY c.id, c.full_name, c.phone, c.email " +
            "ORDER BY booking_count DESC, total_spent DESC " +
            "LIMIT ?",
            (rs, rowNum) -> {
                TopCustomer t = new TopCustomer();
                t.setId(rs.getInt("id"));
                t.setFullName(rs.getString("full_name"));
                t.setPhone(rs.getString("phone"));
                t.setEmail(rs.getString("email"));
                t.setBookingCount(rs.getInt("booking_count"));
                t.setTotalSpent(rs.getBigDecimal("total_spent"));
                t.setLastBookingDate(rs.getString("last_booking"));
                return t;
            }, limit);
    }

    public List<RoomTypeRevenue> getRevenueByRoomType(Timestamp from, Timestamp to) {
        return jdbcTemplate.query(
            "SELECT rt.type_name, SUM(p.amount) AS total_amount, COUNT(DISTINCT p.booking_id) AS booking_count " +
            "FROM payments p " +
            "JOIN bookings b ON p.booking_id = b.id " +
            "JOIN rooms r ON b.room_id = r.id " +
            "JOIN room_types rt ON r.room_type_id = rt.id " +
            "WHERE p.status='PAID' AND p.paid_at >= ? AND p.paid_at < ? " +
            "GROUP BY rt.type_name ORDER BY total_amount DESC",
            (rs, rowNum) -> {
                RoomTypeRevenue r = new RoomTypeRevenue();
                r.setTypeName(rs.getString("type_name"));
                r.setTotalAmount(rs.getBigDecimal("total_amount"));
                r.setBookingCount(rs.getInt("booking_count"));
                return r;
            }, from, to);
    }
}
