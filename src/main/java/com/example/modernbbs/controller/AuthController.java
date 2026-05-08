package com.example.modernbbs.controller;

import com.example.modernbbs.config.AuthInterceptor;
import com.example.modernbbs.model.User;
import com.example.modernbbs.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {
    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String next, Model model) {
        model.addAttribute("next", next == null || next.isBlank() ? "/" : next);
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        @RequestParam(defaultValue = "/") String next,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {
        return userService.login(username, password)
                .map(user -> {
                    session.setAttribute(AuthInterceptor.LOGIN_USER_ID, user.getId());
                    return "redirect:" + safeNext(next);
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("error", "用户名或密码错误");
                    return "redirect:/login?next=" + safeNext(next);
                });
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String username,
                           @RequestParam(required = false) String nickname,
                           @RequestParam String password,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        try {
            User user = userService.register(username, nickname, password);
            session.setAttribute(AuthInterceptor.LOGIN_USER_ID, user.getId());
            return "redirect:/";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            redirectAttributes.addFlashAttribute("username", username);
            redirectAttributes.addFlashAttribute("nickname", nickname);
            return "redirect:/register";
        }
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    private String safeNext(String next) {
        if (next == null || next.isBlank() || !next.startsWith("/") || next.startsWith("//")) {
            return "/";
        }
        return next;
    }
}
