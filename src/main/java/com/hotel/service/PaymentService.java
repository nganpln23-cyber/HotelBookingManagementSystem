package com.hotel.service;

import com.hotel.repository.BookingRepository;
import com.hotel.repository.PaymentRepository;
import com.hotel.model.Booking;
import com.hotel.model.Payment;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class PaymentService {
    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;

    public PaymentService(PaymentRepository paymentRepository, BookingRepository bookingRepository) {
        this.paymentRepository = paymentRepository;
        this.bookingRepository = bookingRepository;
    }

    public List<Payment> findAll() { return paymentRepository.findAll(); }
    public List<Payment> findByBooking(Integer bookingId) { return paymentRepository.findByBookingId(bookingId); }

    public BigDecimal getAmountDue(Integer bookingId) {
        Booking booking = bookingRepository.findById(bookingId);
        BigDecimal paid = paymentRepository.sumPaidByBooking(bookingId);
        BigDecimal due = booking.getTotalAmount().subtract(paid);
        return due.max(BigDecimal.ZERO);
    }

    public boolean isFullyPaid(Integer bookingId) {
        return getAmountDue(bookingId).compareTo(BigDecimal.ZERO) <= 0;
    }

    public void pay(Integer bookingId, BigDecimal amount, String method, String note) {
        Payment p = new Payment();
        p.setBookingId(bookingId);
        p.setAmount(amount);
        p.setMethod(method);
        p.setStatus("PAID");
        p.setNote(note);
        paymentRepository.insert(p);
    }
}
