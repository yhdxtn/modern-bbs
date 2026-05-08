package com.example.modernbbs.config;

import com.example.modernbbs.service.RateLimitService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
public class RateLimitInterceptor implements HandlerInterceptor {
    public static final String CAPTCHA_PASSED_AT = "CAPTCHA_PASSED_AT";

    private final RateLimitService rateLimitService;
    private final long captchaValidMillis;

    public RateLimitInterceptor(RateLimitService rateLimitService,
                                @Value("${app.security.captcha-valid-minutes:30}") long captchaValidMinutes) {
        this.rateLimitService = rateLimitService;
        this.captchaValidMillis = Math.max(1, captchaValidMinutes) * 60_000L;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (!rateLimitService.shouldChallenge(request) || hasFreshCaptcha(request)) {
            return true;
        }
        String next = request.getRequestURI();
        if (request.getQueryString() != null) {
            next += "?" + request.getQueryString();
        }
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            response.sendRedirect("/captcha?next=" + URLEncoder.encode(next, StandardCharsets.UTF_8));
        } else {
            response.setStatus(429);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("访问过于频繁或上传带宽过大，请先打开 /captcha 完成人机验证后再操作。应用层限制不能替代 Nginx/CDN/WAF。 ");
        }
        return false;
    }

    private boolean hasFreshCaptcha(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object passedAt = session == null ? null : session.getAttribute(CAPTCHA_PASSED_AT);
        return passedAt instanceof Long time && System.currentTimeMillis() - time < captchaValidMillis;
    }
}
