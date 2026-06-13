package com.hotel.repository;

import com.hotel.model.Room;
import com.hotel.model.RoomType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@Component
public class RoomRepositoryImpl implements RoomRepository {
    private final JdbcTemplate jdbcTemplate;

    public RoomRepositoryImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

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

    private static final String ROOM_TYPE_COLUMNS = "rt.type_name, rt.price_per_night, rt.max_guests, rt.image_url, rt.image_content_type";

    @Override
    public List<Room> findAll() {
        String sql = "SELECT r.*, " + ROOM_TYPE_COLUMNS +
                " FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id ORDER BY r.id DESC";
        return jdbcTemplate.query(sql, mapper);
    }

    @Override
    public List<Room> findAvailable() {
        String sql = "SELECT r.*, " + ROOM_TYPE_COLUMNS +
                " FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id WHERE r.status = 'AVAILABLE' ORDER BY r.room_number";
        return jdbcTemplate.query(sql, mapper);
    }

    @Override
    public List<Room> findAvailableForDates(LocalDate checkIn, LocalDate checkOut) {
        String sql = "SELECT r.*, " + ROOM_TYPE_COLUMNS +
                " FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id " +
                "WHERE r.status != 'MAINTENANCE' AND r.id NOT IN (" +
                "  SELECT room_id FROM bookings WHERE status IN ('PENDING','CONFIRMED','CHECKED_IN') " +
                "  AND check_in_date < ? AND check_out_date > ?" +
                ") ORDER BY r.room_number";
        return jdbcTemplate.query(sql, mapper, Date.valueOf(checkOut), Date.valueOf(checkIn));
    }

    @Override
    public Room findById(Integer id) {
        String sql = "SELECT r.*, " + ROOM_TYPE_COLUMNS +
                " FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id WHERE r.id=?";
        return jdbcTemplate.queryForObject(sql, mapper, id);
    }

    @Override
    public void insert(Room room) {
        String sql = "INSERT INTO rooms(room_number, room_type_id, floor, status, description) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, room.getRoomNumber(), room.getRoomTypeId(), room.getFloor(), room.getStatus(), room.getDescription());
    }

    @Override
    public void update(Room room) {
        String sql = "UPDATE rooms SET room_number=?, room_type_id=?, floor=?, status=?, description=? WHERE id=?";
        jdbcTemplate.update(sql, room.getRoomNumber(), room.getRoomTypeId(), room.getFloor(), room.getStatus(), room.getDescription(), room.getId());
    }

    @Override
    public void updateStatus(Integer roomId, String status) {
        jdbcTemplate.update("UPDATE rooms SET status=? WHERE id=?", status, roomId);
    }

    @Override
    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM rooms WHERE id=?", id);
    }
}
