package com.hotel.repository;

import com.hotel.model.RoomType;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class RoomTypeRepository {
    private final JdbcTemplate jdbcTemplate;

    public RoomTypeRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private static final String BASE_COLS =
            "id, type_name, description, price_per_night, max_guests, image_url, image_content_type";

    private final RowMapper<RoomType> mapper = (rs, rowNum) -> {
        RoomType rt = new RoomType();
        rt.setId(rs.getInt("id"));
        rt.setTypeName(rs.getString("type_name"));
        rt.setDescription(rs.getString("description"));
        rt.setPricePerNight(rs.getBigDecimal("price_per_night"));
        rt.setMaxGuests(rs.getInt("max_guests"));
        rt.setImageUrl(rs.getString("image_url"));
        rt.setImageContentType(rs.getString("image_content_type"));
        return rt;
    };

    public List<RoomType> findAll() {
        return jdbcTemplate.query("SELECT " + BASE_COLS + " FROM room_types ORDER BY id ASC", mapper);
    }

    public RoomType findById(Integer id) {
        return jdbcTemplate.queryForObject("SELECT " + BASE_COLS + " FROM room_types WHERE id=?", mapper, id);
    }

    public Integer insert(RoomType rt) {
        KeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(conn -> {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO room_types(type_name, description, price_per_night, max_guests, image_url) VALUES (?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, rt.getTypeName()); ps.setString(2, rt.getDescription());
            ps.setBigDecimal(3, rt.getPricePerNight()); ps.setInt(4, rt.getMaxGuests());
            ps.setString(5, rt.getImageUrl());
            return ps;
        }, kh);
        return kh.getKey().intValue();
    }

    public void update(RoomType rt) {
        jdbcTemplate.update(
            "UPDATE room_types SET type_name=?, description=?, price_per_night=?, max_guests=?, image_url=? WHERE id=?",
            rt.getTypeName(), rt.getDescription(), rt.getPricePerNight(), rt.getMaxGuests(), rt.getImageUrl(), rt.getId());
    }

    public void updateImage(Integer id, byte[] data, String contentType) {
        jdbcTemplate.update(
            "UPDATE room_types SET image_data=?, image_content_type=?, image_url=NULL WHERE id=?",
            data, contentType, id);
    }

    public RoomType findImageById(Integer id) {
        try {
            return jdbcTemplate.queryForObject(
                "SELECT image_data, image_content_type FROM room_types WHERE id=?",
                (rs, rowNum) -> {
                    RoomType rt = new RoomType();
                    rt.setImageData(rs.getBytes("image_data"));
                    rt.setImageContentType(rs.getString("image_content_type"));
                    return rt;
                }, id);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM room_types WHERE id=?", id);
    }
}
