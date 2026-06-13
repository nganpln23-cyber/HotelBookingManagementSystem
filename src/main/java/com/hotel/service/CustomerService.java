package com.hotel.service;

import com.hotel.dao.CustomerDAO;
import com.hotel.model.Customer;
import com.hotel.util.PasswordUtil;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerService {
    private final CustomerDAO customerDAO;

    public CustomerService(CustomerDAO customerDAO) {
        this.customerDAO = customerDAO;
    }

    public List<Customer> findAll() { return customerDAO.findAll(); }
    public Customer findById(Integer id) { return customerDAO.findById(id); }
    public void save(Customer customer) {
        if (customer.getId() == null) customerDAO.insert(customer);
        else customerDAO.update(customer);
    }
    public int createAndReturnId(Customer customer) { return customerDAO.insertAndReturnId(customer); }
    public void delete(Integer id) { customerDAO.delete(id); }

    public Customer register(Customer customer) {
        if (customer.getEmail() == null || customer.getEmail().isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập email.");
        }
        if (customer.getPassword() == null || customer.getPassword().isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập mật khẩu.");
        }
        if (customerDAO.findByEmail(customer.getEmail()) != null) {
            throw new IllegalArgumentException("Email này đã được đăng ký.");
        }
        customer.setPassword(PasswordUtil.sha256(customer.getPassword()));
        customer.setId(customerDAO.registerAccount(customer));
        return customer;
    }

    public Customer authenticate(String email, String password) {
        Customer customer = customerDAO.findByEmail(email);
        if (customer == null || customer.getPassword() == null) return null;
        if (!customer.getPassword().equals(PasswordUtil.sha256(password))) return null;
        return customer;
    }
}
