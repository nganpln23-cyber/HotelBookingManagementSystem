package com.hotel.service;

import com.hotel.model.Employee;
import com.hotel.repository.EmployeeRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {
    private final EmployeeRepository employeeRepository;

    public EmployeeService(EmployeeRepository employeeRepository) {
        this.employeeRepository = employeeRepository;
    }

    public List<Employee> findAll() { return employeeRepository.findAll(); }
    public List<Employee> search(String keyword) { return employeeRepository.search(keyword); }
    public Employee findById(Integer id) { return employeeRepository.findById(id); }

    public void save(Employee e) {
        if (e.getFullName() == null || e.getFullName().isBlank())
            throw new IllegalArgumentException("Vui lòng nhập họ tên nhân viên.");
        if (e.getPosition() == null || e.getPosition().isBlank())
            throw new IllegalArgumentException("Vui lòng nhập chức vụ.");
        if (e.getDepartment() == null || e.getDepartment().isBlank())
            throw new IllegalArgumentException("Vui lòng nhập phòng ban.");
        if (e.getId() == null) employeeRepository.insert(e);
        else employeeRepository.update(e);
    }

    public void delete(Integer id) { employeeRepository.delete(id); }
}
