package com.hotel.repository;

import com.hotel.model.Room;
import com.hotel.model.RoomType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Repository
public class RoomRepository {
    private final JdbcTemplate jdbcTemplate;

    public RoomRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private static final String RT_COLS =
            "rt.type_name, rt.price_per_night, rt.max_guests, rt.image_url, rt.image_content_type";

    private final RowMapper<Room> mapper = (rs, rowNum) -> {
        Room room = new Room();
        room.setId(rs.getInt("id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomTypeId(rs.getInt("room_type_id"));
        room.setFloor(rs.getInt("floor"));
        room.setStatus(rs.getString("status"));
        room.setDescription(rs.getString("description"));
        RoomType rt = new RoomType();
        rt.setId(rs.getInt("room_type_id"));
        rt.setTypeName(rs.getString("type_name"));
        rt.setPricePerNight(rs.getBigDecimal("price_per_night"));
        rt.setMaxGuests(rs.getInt("max_guests"));
        rt.setImageUrl(rs.getString("image_url"));
        rt.setImageContentType(rs.getString("image_content_type"));
        room.setRoomType(rt);
        return room;
    };

    private static final String JOIN_SQL =
            "SELECT r.*, " + RT_COLS + " FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id ";

    public List<Room> findAll() {
        return jdbcTemplate.query(JOIN_SQL + "ORDER BY r.room_number ASC", mapper);
    }

    public List<Room> search(String keyword, String status) {
        StringBuilder sql = new StringBuilder(JOIN_SQL + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isBlank()) {
            sql.append("AND r.status=? ");
            params.add(status);
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (r.room_number LIKE ? OR rt.type_name LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like); params.add(like);
        }
        sql.append("ORDER BY r.room_number");
        return jdbcTemplate.query(sql.toString(), mapper, params.toArray());
    }

    public List<Room> findAvailable() {
        return jdbcTemplate.query(JOIN_SQL + "WHERE r.status='AVAILABLE' ORDER BY r.room_number", mapper);
    }

    public List<Room> findAvailableForDates(LocalDate checkIn, LocalDate checkOut) {
        return jdbcTemplate.query(
            JOIN_SQL +
            "WHERE r.status != 'MAINTENANCE' AND r.id NOT IN (" +
            "  SELECT room_id FROM bookings WHERE status IN ('PENDING','CONFIRMED','CHECKED_IN') " +
            "  AND check_in_date < ? AND check_out_date > ?" +
            ") ORDER BY r.room_number",
            mapper, Date.valueOf(checkOut), Date.valueOf(checkIn));
    }

    public Room findById(Integer id) {
        return jdbcTemplate.queryForObject(JOIN_SQL + "WHERE r.id=?", mapper, id);
    }

    public void insert(Room r) {
        jdbcTemplate.update(
            "INSERT INTO rooms(room_number, room_type_id, floor, status, description) VALUES (?,?,?,?,?)",
            r.getRoomNumber(), r.getRoomTypeId(), r.getFloor(), r.getStatus(), r.getDescription());
    }

    public void update(Room r) {
        jdbcTemplate.update(
            "UPDATE rooms SET room_number=?, room_type_id=?, floor=?, status=?, description=? WHERE id=?",
            r.getRoomNumber(), r.getRoomTypeId(), r.getFloor(), r.getStatus(), r.getDescription(), r.getId());
    }

    public void updateStatus(Integer id, String status) {
        jdbcTemplate.update("UPDATE rooms SET status=? WHERE id=?", status, id);
    }

    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM rooms WHERE id=?", id);
    }
}
