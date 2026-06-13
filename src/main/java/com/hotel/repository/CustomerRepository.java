package com.hotel.repository;

import com.hotel.model.Customer;
import java.util.List;

public interface CustomerRepository {
    List<Customer> findAll();
    Customer findById(Integer id);
    Customer findByEmail(String email);
    void insert(Customer customer);
    int insertAndReturnId(Customer customer);
    int registerAccount(Customer customer);
    void update(Customer customer);
    void delete(Integer id);
}
