package com.example.modernbbs.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
public class AuthInterceptor implements HandlerInterceptor {
    public static final String LOGIN_USER_ID = "LOGIN_USER_ID";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        Object userId = session == null ? null : session.getAttribute(LOGIN_USER_ID);
        if (userId != null) {
            return true;
        }
        String next = request.getRequestURI();
        if (request.getQueryString() != null) {
            next += "?" + request.getQueryString();
        }
        response.sendRedirect("/login?next=" + URLEncoder.encode(next, StandardCharsets.UTF_8));
        return false;
    }
}
