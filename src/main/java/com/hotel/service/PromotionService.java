package com.hotel.service;

import com.hotel.dao.BookingDAO;
import com.hotel.dao.PromotionDAO;
import com.hotel.model.Promotion;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PromotionService {
    private final PromotionDAO promotionDAO;
    private final BookingDAO bookingDAO;

    public PromotionService(PromotionDAO promotionDAO, BookingDAO bookingDAO) {
        this.promotionDAO = promotionDAO;
        this.bookingDAO = bookingDAO;
    }

    public List<Promotion> findEligiblePromotions(Integer customerId) {
        int completed = bookingDAO.countCompletedByCustomer(customerId);
        return promotionDAO.findActive().stream()
                .filter(p -> completed >= p.getMinCompletedBookings())
                .collect(Collectors.toList());
    }

    /** Validates a promo code for the given customer and returns its discount percent. */
    public BigDecimal validate(String code, Integer customerId) {
        Promotion promo = promotionDAO.findByCode(code);
        if (promo == null) {
            throw new IllegalArgumentException("Mã giảm giá không hợp lệ.");
        }
        int completed = bookingDAO.countCompletedByCustomer(customerId);
        if (completed < promo.getMinCompletedBookings()) {
            throw new IllegalArgumentException("Bạn chưa đủ điều kiện sử dụng mã giảm giá này.");
        }
        return promo.getDiscountPercent();
    }
}
