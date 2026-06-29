package com.hotel.repository;

import com.hotel.model.Customer;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class CustomerRepository {
    private final JdbcTemplate jdbcTemplate;

    public CustomerRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Customer> mapper = (rs, rowNum) -> {
        Customer c = new Customer();
        c.setId(rs.getInt("id"));
        c.setFullName(rs.getString("full_name"));
        c.setPhone(rs.getString("phone"));
        c.setEmail(rs.getString("email"));
        c.setIdentityNumber(rs.getString("identity_number"));
        c.setAddress(rs.getString("address"));
        c.setPassword(rs.getString("password"));
        return c;
    };

    public List<Customer> findAll() {
        return jdbcTemplate.query("SELECT * FROM customers ORDER BY id ASC", mapper);
    }

    public List<Customer> search(String keyword) {
        if (keyword == null || keyword.isBlank()) return findAll();
        String like = "%" + keyword.trim() + "%";
        return jdbcTemplate.query(
            "SELECT * FROM customers WHERE full_name LIKE ? OR phone LIKE ? OR email LIKE ? OR identity_number LIKE ? ORDER BY id ASC",
            mapper, like, like, like, like);
    }

    public Customer findById(Integer id) {
        return jdbcTemplate.queryForObject("SELECT * FROM customers WHERE id=?", mapper, id);
    }

    public Customer findByEmail(String email) {
        List<Customer> r = jdbcTemplate.query("SELECT * FROM customers WHERE email=? LIMIT 1", mapper, email);
        return r.isEmpty() ? null : r.get(0);
    }

    public void insert(Customer c) {
        jdbcTemplate.update(
            "INSERT INTO customers(full_name, phone, email, identity_number, address) VALUES (?,?,?,?,?)",
            c.getFullName(), c.getPhone(), c.getEmail(), c.getIdentityNumber(), c.getAddress());
    }

    public int insertAndReturnId(Customer c) {
        KeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(conn -> {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO customers(full_name, phone, email, identity_number, address) VALUES (?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, c.getFullName()); ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail()); ps.setString(4, c.getIdentityNumber());
            ps.setString(5, c.getAddress());
            return ps;
        }, kh);
        return kh.getKey().intValue();
    }

    public int registerAccount(Customer c) {
        KeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(conn -> {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO customers(full_name, phone, email, identity_number, address, password) VALUES (?,?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, c.getFullName()); ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail()); ps.setString(4, c.getIdentityNumber());
            ps.setString(5, c.getAddress()); ps.setString(6, c.getPassword());
            return ps;
        }, kh);
        return kh.getKey().intValue();
    }

    public void update(Customer c) {
        jdbcTemplate.update(
            "UPDATE customers SET full_name=?, phone=?, email=?, identity_number=?, address=? WHERE id=?",
            c.getFullName(), c.getPhone(), c.getEmail(), c.getIdentityNumber(), c.getAddress(), c.getId());
    }

    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM customers WHERE id=?", id);
    }
}
