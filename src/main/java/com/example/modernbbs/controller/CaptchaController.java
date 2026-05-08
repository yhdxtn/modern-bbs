package com.example.modernbbs.controller;

import com.example.modernbbs.config.RateLimitInterceptor;
import com.example.modernbbs.service.RateLimitService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.SecureRandom;

@Controller
public class CaptchaController {
    private static final String CAPTCHA_ANSWER = "CAPTCHA_ANSWER";
    private final SecureRandom random = new SecureRandom();
    private final RateLimitService rateLimitService;

    public CaptchaController(RateLimitService rateLimitService) {
        this.rateLimitService = rateLimitService;
    }

    @GetMapping("/captcha")
    public String captcha(@RequestParam(defaultValue = "/") String next, HttpSession session, Model model) {
        int a = 10 + random.nextInt(40);
        int b = 1 + random.nextInt(9);
        session.setAttribute(CAPTCHA_ANSWER, a + b);
        model.addAttribute("question", a + " + " + b + " = ?");
        model.addAttribute("next", safeNext(next));
        return "captcha";
    }

    @PostMapping("/captcha")
    public String verify(@RequestParam String answer,
                         @RequestParam(defaultValue = "/") String next,
                         HttpServletRequest request,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        Object expected = session.getAttribute(CAPTCHA_ANSWER);
        int input;
        try {
            input = Integer.parseInt(answer.trim());
        } catch (Exception ex) {
            input = Integer.MIN_VALUE;
        }
        if (expected instanceof Integer value && value == input) {
            session.setAttribute(RateLimitInterceptor.CAPTCHA_PASSED_AT, System.currentTimeMillis());
            session.removeAttribute(CAPTCHA_ANSWER);
            rateLimitService.markCaptchaPassed(request);
            return "redirect:" + safeNext(next);
        }
        redirectAttributes.addFlashAttribute("error", "验证失败，请重新计算");
        return "redirect:/captcha?next=" + safeNext(next);
    }

    private String safeNext(String next) {
        if (next == null || next.isBlank() || !next.startsWith("/") || next.startsWith("//")) {
            return "/";
        }
        return next;
    }
}
