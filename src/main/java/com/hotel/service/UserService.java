package com.hotel.service;

import com.hotel.repository.UserRepository;
import com.hotel.model.User;
import com.hotel.util.PasswordUtil;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User authenticate(String username, String password) {
        User user = userRepository.findByUsername(username);
        if (user == null) return null;
        if (!user.getPassword().equals(PasswordUtil.sha256(password))) return null;
        return user;
    }
}
