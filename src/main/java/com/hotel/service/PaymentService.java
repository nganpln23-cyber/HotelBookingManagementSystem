package com.hotel.service;

import com.hotel.dao.BookingDAO;
import com.hotel.dao.PaymentDAO;
import com.hotel.model.Booking;
import com.hotel.model.Payment;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class PaymentService {
    private final PaymentDAO paymentDAO;
    private final BookingDAO bookingDAO;

    public PaymentService(PaymentDAO paymentDAO, BookingDAO bookingDAO) {
        this.paymentDAO = paymentDAO;
        this.bookingDAO = bookingDAO;
    }

    public List<Payment> findAll() { return paymentDAO.findAll(); }
    public List<Payment> findByBooking(Integer bookingId) { return paymentDAO.findByBookingId(bookingId); }

    public BigDecimal getAmountDue(Integer bookingId) {
        Booking booking = bookingDAO.findById(bookingId);
        BigDecimal paid = paymentDAO.sumPaidByBooking(bookingId);
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
        paymentDAO.insert(p);
    }
}
