package com.hotel.service;

import com.hotel.dao.UserDAO;
import com.hotel.model.User;
import com.hotel.util.PasswordUtil;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserDAO userDAO;

    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public User authenticate(String username, String password) {
        User user = userDAO.findByUsername(username);
        if (user == null) return null;
        if (!user.getPassword().equals(PasswordUtil.sha256(password))) return null;
        return user;
    }
}
