package com.hotel.dao;

import com.hotel.model.Promotion;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class PromotionDAO {
    private final JdbcTemplate jdbcTemplate;

    public PromotionDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Promotion> mapper = (rs, rowNum) -> {
        Promotion p = new Promotion();
        p.setId(rs.getInt("id"));
        p.setCode(rs.getString("code"));
        p.setDescription(rs.getString("description"));
        p.setDiscountPercent(rs.getBigDecimal("discount_percent"));
        p.setMinCompletedBookings(rs.getInt("min_completed_bookings"));
        p.setActive(rs.getBoolean("active"));
        return p;
    };

    public List<Promotion> findActive() {
        return jdbcTemplate.query("SELECT * FROM promotions WHERE active=1 ORDER BY min_completed_bookings", mapper);
    }

    public Promotion findByCode(String code) {
        try {
            return jdbcTemplate.queryForObject("SELECT * FROM promotions WHERE code=? AND active=1", mapper, code);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }
}
