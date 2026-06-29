package com.hotel.repository;

import com.hotel.model.Employee;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class EmployeeRepository {
    private final JdbcTemplate jdbcTemplate;

    public EmployeeRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Employee> mapper = (rs, rowNum) -> {
        Employee e = new Employee();
        e.setId(rs.getInt("id"));
        e.setFullName(rs.getString("full_name"));
        e.setPhone(rs.getString("phone"));
        e.setEmail(rs.getString("email"));
        e.setIdentityNumber(rs.getString("identity_number"));
        e.setAddress(rs.getString("address"));
        e.setPosition(rs.getString("position"));
        e.setDepartment(rs.getString("department"));
        java.sql.Date d = rs.getDate("hire_date");
        if (d != null) e.setHireDate(d.toLocalDate());
        e.setSalary(rs.getBigDecimal("salary"));
        e.setStatus(rs.getString("status"));
        e.setNote(rs.getString("note"));
        return e;
    };

    public List<Employee> findAll() {
        return jdbcTemplate.query("SELECT * FROM employees ORDER BY id ASC", mapper);
    }

    public List<Employee> search(String keyword) {
        if (keyword == null || keyword.isBlank()) return findAll();
        String like = "%" + keyword.trim() + "%";
        return jdbcTemplate.query(
            "SELECT * FROM employees WHERE full_name LIKE ? OR phone LIKE ? OR position LIKE ? OR department LIKE ? ORDER BY id ASC",
            mapper, like, like, like, like);
    }

    public Employee findById(Integer id) {
        return jdbcTemplate.queryForObject("SELECT * FROM employees WHERE id=?", mapper, id);
    }

    public void insert(Employee e) {
        KeyHolder kh = new GeneratedKeyHolder();
        jdbcTemplate.update(conn -> {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO employees(full_name,phone,email,identity_number,address,position,department,hire_date,salary,status,note) VALUES(?,?,?,?,?,?,?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, e.getFullName()); ps.setString(2, e.getPhone());
            ps.setString(3, e.getEmail()); ps.setString(4, e.getIdentityNumber());
            ps.setString(5, e.getAddress()); ps.setString(6, e.getPosition());
            ps.setString(7, e.getDepartment());
            ps.setObject(8, e.getHireDate());
            ps.setBigDecimal(9, e.getSalary());
            ps.setString(10, e.getStatus() != null ? e.getStatus() : "ACTIVE");
            ps.setString(11, e.getNote());
            return ps;
        }, kh);
        e.setId(kh.getKey().intValue());
    }

    public void update(Employee e) {
        jdbcTemplate.update(
            "UPDATE employees SET full_name=?,phone=?,email=?,identity_number=?,address=?,position=?,department=?,hire_date=?,salary=?,status=?,note=? WHERE id=?",
            e.getFullName(), e.getPhone(), e.getEmail(), e.getIdentityNumber(), e.getAddress(),
            e.getPosition(), e.getDepartment(), e.getHireDate(), e.getSalary(),
            e.getStatus(), e.getNote(), e.getId());
    }

    public void delete(Integer id) {
        jdbcTemplate.update("DELETE FROM employees WHERE id=?", id);
    }
}
