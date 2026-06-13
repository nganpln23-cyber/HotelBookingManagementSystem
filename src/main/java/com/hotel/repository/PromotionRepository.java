package com.hotel.repository;

import com.hotel.model.Promotion;
import java.util.List;

public interface PromotionRepository {
    List<Promotion> findActive();
    Promotion findByCode(String code);
}
