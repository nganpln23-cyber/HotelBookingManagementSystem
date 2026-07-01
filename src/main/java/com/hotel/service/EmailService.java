package com.hotel.service;

import com.hotel.model.Booking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Service
public class EmailService {

    @Autowired(required = false)
    private JavaMailSenderImpl mailSenderImpl;

    private JavaMailSender mailSender;

    @jakarta.annotation.PostConstruct
    private void init() {
        if (mailSenderImpl != null) {
            String user = mailSenderImpl.getUsername();
            if (user != null && !user.isBlank()) {
                mailSender = mailSenderImpl;
            }
        }
    }

    private static final String FROM = "Grand Beach Hotel <noreply@grandbeach.vn>";
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final NumberFormat NUM_FMT = NumberFormat.getNumberInstance(new Locale("vi", "VN"));

    public String sendTestEmail(String toEmail) {
        if (mailSender == null) return "FAIL: mailSender bean is null (SMTP not configured)";
        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper h = new MimeMessageHelper(msg, true, "UTF-8");
            h.setFrom(FROM);
            h.setTo(toEmail);
            h.setSubject("Grand Beach Hotel – Test email");
            h.setText("<p>Email test thành công! SMTP đang hoạt động.</p>", true);
            mailSender.send(msg);
            return "OK: email sent to " + toEmail;
        } catch (Exception e) {
            return "FAIL: " + e.getMessage();
        }
    }

    public void sendPaymentReceived(String toEmail, String name, Booking b) {
        if (mailSender == null || toEmail == null || toEmail.isBlank()) return;
        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper h = new MimeMessageHelper(msg, true, "UTF-8");
            h.setFrom(FROM);
            h.setTo(toEmail);
            h.setSubject("Grand Beach Hotel – Đã nhận thanh toán, đang xác nhận đặt phòng");
            h.setText(paymentReceivedHtml(name, b), true);
            mailSender.send(msg);
        } catch (Exception e) {
            System.err.println("[EmailService] Failed to send payment-received email: " + e.getMessage());
        }
    }

    public void sendBookingConfirmed(String toEmail, String name, Booking b) {
        if (mailSender == null || toEmail == null || toEmail.isBlank()) return;
        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper h = new MimeMessageHelper(msg, true, "UTF-8");
            h.setFrom(FROM);
            h.setTo(toEmail);
            h.setSubject("Grand Beach Hotel – Đặt phòng " + b.getConfirmationCode() + " đã được xác nhận! 🎉");
            h.setText(bookingConfirmedHtml(name, b), true);
            mailSender.send(msg);
        } catch (Exception e) {
            System.err.println("[EmailService] Failed to send booking-confirmed email: " + e.getMessage());
        }
    }

    private String paymentReceivedHtml(String name, Booking b) {
        return emailWrapper(
            "Chúng tôi đã nhận được thanh toán của bạn",
            "#f59e0b",
            "<p style='font-size:15px;'>Xin chào <strong>" + esc(name) + "</strong>,</p>" +
            "<p style='font-size:15px;'>Chúng tôi đã nhận được thanh toán trực tuyến của bạn cho đặt phòng tại <strong>Grand Beach Hotel</strong>.</p>" +
            bookingSummaryBlock(b) +
            "<p style='font-size:14px;color:#64748b;'>Đội ngũ của chúng tôi đang xem xét và sẽ <strong>xác nhận đặt phòng trong vòng 30 phút</strong>. Bạn sẽ nhận được email xác nhận ngay sau khi đặt phòng được duyệt.</p>" +
            "<p style='font-size:14px;color:#64748b;'>Mã giao dịch: <code style='background:#f1f5f9;padding:2px 6px;border-radius:4px;'>" + esc(b.getOnlinePaymentRef()) + "</code></p>"
        );
    }

    private String bookingConfirmedHtml(String name, Booking b) {
        return emailWrapper(
            "Đặt phòng đã được xác nhận! 🎉",
            "#10b981",
            "<p style='font-size:15px;'>Xin chào <strong>" + esc(name) + "</strong>,</p>" +
            "<p style='font-size:15px;'>Đặt phòng của bạn tại <strong>Grand Beach Hotel</strong> đã được <span style='color:#10b981;font-weight:700;'>xác nhận thành công</span>.</p>" +
            bookingSummaryBlock(b) +
            "<div style='background:#ecfdf5;border:1px solid #a7f3d0;border-radius:8px;padding:16px;margin:20px 0;'>" +
            "<p style='margin:0;font-size:14px;'><strong>Mã xác nhận của bạn:</strong> " +
            "<span style='font-size:18px;font-weight:700;color:#059669;letter-spacing:2px;'>" + esc(b.getConfirmationCode()) + "</span></p>" +
            "<p style='margin:6px 0 0;font-size:13px;color:#6b7280;'>Vui lòng lưu mã này để xuất trình khi check-in.</p></div>" +
            "<p style='font-size:14px;color:#64748b;'>Chúng tôi rất mong được đón tiếp bạn. Nếu có bất kỳ câu hỏi nào, vui lòng liên hệ chúng tôi.</p>"
        );
    }

    private String bookingSummaryBlock(Booking b) {
        return "<div style='background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;padding:16px;margin:20px 0;'>" +
               "<table style='width:100%;border-collapse:collapse;font-size:14px;'>" +
               "<tr><td style='padding:6px 0;color:#64748b;'>Phòng</td><td style='text-align:right;font-weight:600;'>" + esc(b.getRoomNumber()) + " – " + esc(b.getRoomTypeName()) + "</td></tr>" +
               "<tr><td style='padding:6px 0;color:#64748b;'>Nhận phòng</td><td style='text-align:right;font-weight:600;'>" + b.getCheckInDate().format(DATE_FMT) + "</td></tr>" +
               "<tr><td style='padding:6px 0;color:#64748b;'>Trả phòng</td><td style='text-align:right;font-weight:600;'>" + b.getCheckOutDate().format(DATE_FMT) + "</td></tr>" +
               "<tr style='border-top:1px solid #e2e8f0;'><td style='padding:10px 0 4px;font-weight:700;'>Tổng thanh toán</td><td style='text-align:right;font-size:16px;font-weight:700;color:#1e293b;padding:10px 0 4px;'>" + NUM_FMT.format(b.getTotalAmount()) + "₫</td></tr>" +
               "</table></div>";
    }

    private String emailWrapper(String title, String accentColor, String body) {
        return "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body style='margin:0;padding:0;background:#f1f5f9;font-family:Inter,Helvetica,Arial,sans-serif;'>" +
               "<div style='max-width:600px;margin:40px auto;background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,.08);'>" +
               "<div style='background:#0f172a;padding:28px 32px;text-align:center;'>" +
               "<span style='font-size:24px;font-weight:800;color:#fff;letter-spacing:-0.5px;'>🏖️ Grand<span style='color:" + accentColor + ";'>.</span>Beach</span>" +
               "</div>" +
               "<div style='padding:32px;'>" +
               "<h2 style='font-size:20px;font-weight:700;color:#0f172a;margin:0 0 20px;'>" + title + "</h2>" +
               body +
               "</div>" +
               "<div style='background:#f8fafc;border-top:1px solid #e2e8f0;padding:20px 32px;text-align:center;font-size:12px;color:#94a3b8;'>" +
               "Grand Beach Hotel &mdash; Hệ thống quản lý đặt phòng<br>Email này được gửi tự động, vui lòng không trả lời." +
               "</div></div></body></html>";
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
