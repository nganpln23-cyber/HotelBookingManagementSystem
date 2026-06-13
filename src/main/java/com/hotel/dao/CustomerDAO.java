package com.hotel.dao;

import com.hotel.model.Customer;
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
public class CustomerDAO {
    private final JdbcTemplate jdbcTemplate;

    public CustomerDAO(JdbcTemplate jdbcTemplate) {
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
        return jdbcTemplate.query("SELECT * FROM customers ORDER BY id DESC", mapper);
    }

    public Customer findById(Integer id) {
        return jdbcTemplate.queryForObject("SELECT * FROM customers WHERE id=?", mapper, id);
    }

    public Customer findByEmail(String email) {
        try {
            return jdbcTemplate.queryForObject("SELECT * FROM customers WHERE email=?", mapper, email);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    public void insert(Customer customer) {
        String sql = "INSERT INTO customers(full_name, phone, email, identity_number, address) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, customer.getFullName(), customer.getPhone(), customer.getEmail(), customer.getIdentityNumber(), customer.getAddress());
    }

    public int insertAndReturnId(Customer customer) {
        String sql = "INSERT INTO customers(full_name, phone, email, identity_number, address) VALUES (?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getIdentityNumber());
            ps.setString(5, customer.getAddress());
            return ps;
        }, keyHolder);
        return keyHolder.getKey().intValue();
    }

    public int registerAccount(Customer customer) {
        String sql = "INSERT INTO customers(full_name, phone, email, identity_number, address, password) VALUES (?, ?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getIdentityNumber());
            ps.setString(5, customer.getAddress());
            ps.setString(6, customer.getPassword());
            return ps;
        }, keyHolder);
        return keyHolder.getKey().intValue();
    }

    public void update(Customer customer) {
        String sql = "UPDATE customers SET full_name=?, phone=?, email=?, identity_number=?, address=? WHERE id=?";
        jdbcTemplate.update(sql, customer.getFullName(), customer.getPhone(), customer.getEmail(), customer.getIdentityNumber(), customer.getAddress(), customer.getId());
    }

    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM customers WHERE id=?", id);
    }
}
