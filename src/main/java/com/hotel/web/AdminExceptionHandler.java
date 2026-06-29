package com.hotel.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.Map;

@ControllerAdvice(basePackages = "com.hotel.controller")
public class AdminExceptionHandler {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    @ExceptionHandler({IllegalStateException.class, IllegalArgumentException.class})
    public ModelAndView handleBusinessError(RuntimeException ex, HttpServletRequest request,
                                            HttpServletResponse response,
                                            RedirectAttributes redirectAttributes) throws IOException {
        if (isAjaxRequest(request)) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, ex.getMessage());
            return null;
        }
        redirectAttributes.addFlashAttribute("error", ex.getMessage());
        return new ModelAndView("redirect:" + fallbackPath(request));
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ModelAndView handleDataIntegrityError(HttpServletRequest request,
                                                  HttpServletResponse response,
                                                  RedirectAttributes redirectAttributes) throws IOException {
        String msg = "Không thể thực hiện vì dữ liệu này đang được sử dụng ở nơi khác.";
        if (isAjaxRequest(request)) {
            writeJson(response, HttpServletResponse.SC_CONFLICT, msg);
            return null;
        }
        redirectAttributes.addFlashAttribute("error", msg);
        return new ModelAndView("redirect:" + fallbackPath(request));
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        return "XMLHttpRequest".equals(requestedWith)
                || (accept != null && accept.contains(MediaType.APPLICATION_JSON_VALUE));
    }

    private void writeJson(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        MAPPER.writeValue(response.getWriter(), Map.of("error", message));
    }

    private String fallbackPath(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isBlank()) {
            return referer;
        }
        return "/admin/dashboard";
    }
}
