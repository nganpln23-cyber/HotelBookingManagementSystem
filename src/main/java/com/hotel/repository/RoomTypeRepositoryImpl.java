package com.hotel.repository;

import com.hotel.model.RoomType;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Component;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Component
public class RoomTypeRepositoryImpl implements RoomTypeRepository {
    private final JdbcTemplate jdbcTemplate;

    public RoomTypeRepositoryImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private static final String BASE_COLUMNS =
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

    @Override
    public List<RoomType> findAll() {
        return jdbcTemplate.query("SELECT " + BASE_COLUMNS + " FROM room_types ORDER BY id DESC", mapper);
    }

    @Override
    public RoomType findById(Integer id) {
        return jdbcTemplate.queryForObject("SELECT " + BASE_COLUMNS + " FROM room_types WHERE id = ?", mapper, id);
    }

    @Override
    public Integer insert(RoomType roomType) {
        String sql = "INSERT INTO room_types(type_name, description, price_per_night, max_guests, image_url) VALUES (?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, roomType.getTypeName());
            ps.setString(2, roomType.getDescription());
            ps.setBigDecimal(3, roomType.getPricePerNight());
            ps.setInt(4, roomType.getMaxGuests());
            ps.setString(5, roomType.getImageUrl());
            return ps;
        }, keyHolder);
        return keyHolder.getKey().intValue();
    }

    @Override
    public void update(RoomType roomType) {
        String sql = "UPDATE room_types SET type_name=?, description=?, price_per_night=?, max_guests=?, image_url=? WHERE id=?";
        jdbcTemplate.update(sql, roomType.getTypeName(), roomType.getDescription(), roomType.getPricePerNight(), roomType.getMaxGuests(), roomType.getImageUrl(), roomType.getId());
    }

    @Override
    public void updateImage(Integer id, byte[] imageData, String imageContentType) {
        jdbcTemplate.update("UPDATE room_types SET image_data=?, image_content_type=? WHERE id=?", imageData, imageContentType, id);
    }

    @Override
    public RoomType findImageById(Integer id) {
        try {
            return jdbcTemplate.queryForObject("SELECT image_data, image_content_type FROM room_types WHERE id = ?", (rs, rowNum) -> {
                RoomType rt = new RoomType();
                rt.setImageData(rs.getBytes("image_data"));
                rt.setImageContentType(rs.getString("image_content_type"));
                return rt;
            }, id);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    @Override
    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM room_types WHERE id=?", id);
    }
}
