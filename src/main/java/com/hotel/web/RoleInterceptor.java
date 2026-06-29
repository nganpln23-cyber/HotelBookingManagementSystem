package com.hotel.web;

import com.hotel.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class RoleInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null) return true; // LoginInterceptor handles unauthenticated

        User user = (User) session.getAttribute("currentUser");
        if (user == null) return true;

        String role = user.getRole();
        if (role == null || "ADMIN".equals(role)) return true; // ADMIN: full access

        String path = request.getRequestURI();
        String ctx = request.getContextPath();
        String relPath = path.startsWith(ctx) ? path.substring(ctx.length()) : path;

        boolean allowed = switch (role) {
            case "MANAGER" ->
                relPath.startsWith("/admin/dashboard") ||
                relPath.startsWith("/admin/reports");
            case "RECEPTIONIST" ->
                relPath.startsWith("/admin/dashboard") ||
                relPath.startsWith("/admin/bookings") ||
                relPath.startsWith("/admin/checkinout") ||
                relPath.startsWith("/admin/payments") ||
                relPath.startsWith("/admin/customers");
            case "ROOM_STAFF" ->
                relPath.startsWith("/admin/dashboard") ||
                relPath.startsWith("/admin/rooms");
            default -> false;
        };

        if (!allowed) {
            request.getSession().setAttribute("error", "Bạn không có quyền truy cập trang này.");
            response.sendRedirect(ctx + "/admin/dashboard");
            return false;
        }
        return true;
    }
}
