package com.hotel.repository;

import com.hotel.model.User;

public interface UserRepository {
    User findByUsername(String username);
}
