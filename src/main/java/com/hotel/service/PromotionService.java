package com.hotel.service;

import com.hotel.repository.BookingRepository;
import com.hotel.repository.PromotionRepository;
import com.hotel.model.Promotion;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PromotionService {
    private final PromotionRepository promotionRepository;
    private final BookingRepository bookingRepository;

    public PromotionService(PromotionRepository promotionRepository, BookingRepository bookingRepository) {
        this.promotionRepository = promotionRepository;
        this.bookingRepository = bookingRepository;
    }

    public List<Promotion> findEligiblePromotions(Integer customerId) {
        int completed = bookingRepository.countCompletedByCustomer(customerId);
        return promotionRepository.findActive().stream()
                .filter(p -> completed >= p.getMinCompletedBookings())
                .collect(Collectors.toList());
    }

    /** Validates a promo code for the given customer and returns its discount percent. */
    public BigDecimal validate(String code, Integer customerId) {
        Promotion promo = promotionRepository.findByCode(code);
        if (promo == null) {
            throw new IllegalArgumentException("Mã giảm giá không hợp lệ.");
        }
        int completed = bookingRepository.countCompletedByCustomer(customerId);
        if (completed < promo.getMinCompletedBookings()) {
            throw new IllegalArgumentException("Bạn chưa đủ điều kiện sử dụng mã giảm giá này.");
        }
        return promo.getDiscountPercent();
    }
}
