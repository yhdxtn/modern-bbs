package com.example.modernbbs.config;

import com.example.modernbbs.model.User;
import com.example.modernbbs.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
public class AdminInterceptor implements HandlerInterceptor {
    private final UserService userService;

    public AdminInterceptor(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        Object userId = session == null ? null : session.getAttribute(AuthInterceptor.LOGIN_USER_ID);
        if (!(userId instanceof Long id)) {
            String next = request.getRequestURI();
            if (request.getQueryString() != null) {
                next += "?" + request.getQueryString();
            }
            response.sendRedirect("/login?next=" + URLEncoder.encode(next, StandardCharsets.UTF_8));
            return false;
        }

        User user = userService.findById(id).orElse(null);
        if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
            return true;
        }

        response.sendRedirect("/error-admin");
        return false;
    }
}
