package com.hotel.service;

import com.hotel.repository.CustomerRepository;
import com.hotel.model.Customer;
import com.hotel.util.PasswordUtil;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerService {
    private final CustomerRepository customerRepository;

    public CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    public List<Customer> findAll() { return customerRepository.findAll(); }
    public Customer findById(Integer id) { return customerRepository.findById(id); }
    public void save(Customer customer) {
        if (customer.getId() == null) customerRepository.insert(customer);
        else customerRepository.update(customer);
    }
    public int createAndReturnId(Customer customer) { return customerRepository.insertAndReturnId(customer); }
    public void delete(Integer id) { customerRepository.delete(id); }

    public Customer register(Customer customer) {
        if (customer.getEmail() == null || customer.getEmail().isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập email.");
        }
        if (customer.getPassword() == null || customer.getPassword().isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập mật khẩu.");
        }
        if (customerRepository.findByEmail(customer.getEmail()) != null) {
            throw new IllegalArgumentException("Email này đã được đăng ký.");
        }
        customer.setPassword(PasswordUtil.sha256(customer.getPassword()));
        customer.setId(customerRepository.registerAccount(customer));
        return customer;
    }

    public Customer authenticate(String email, String password) {
        Customer customer = customerRepository.findByEmail(email);
        if (customer == null || customer.getPassword() == null) return null;
        if (!customer.getPassword().equals(PasswordUtil.sha256(password))) return null;
        return customer;
    }
}
