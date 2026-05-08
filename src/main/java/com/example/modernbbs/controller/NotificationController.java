package com.example.modernbbs.controller;

import com.example.modernbbs.config.AuthInterceptor;
import com.example.modernbbs.model.User;
import com.example.modernbbs.service.NotificationService;
import com.example.modernbbs.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/notifications")
public class NotificationController {
    private final NotificationService notificationService;
    private final UserService userService;

    public NotificationController(NotificationService notificationService, UserService userService) {
        this.notificationService = notificationService;
        this.userService = userService;
    }

    @GetMapping
    public String list(HttpSession session, Model model) {
        User user = currentUser(session);
        model.addAttribute("notifications", notificationService.latest(user));
        return "notifications";
    }

    @PostMapping("/read-all")
    public String readAll(HttpSession session) {
        notificationService.markAllRead(currentUser(session));
        return "redirect:/notifications";
    }

    @PostMapping("/{id}/read")
    public String readOne(@PathVariable Long id, @RequestParam(required = false, defaultValue = "/notifications") String next, HttpSession session) {
        notificationService.markRead(id, currentUser(session));
        if (next == null || !next.startsWith("/")) return "redirect:/notifications";
        return "redirect:" + next;
    }

    private User currentUser(HttpSession session) {
        Object id = session.getAttribute(AuthInterceptor.LOGIN_USER_ID);
        if (!(id instanceof Long userId)) {
            throw new IllegalArgumentException("请先登入后再查看消息");
        }
        return userService.findById(userId).orElseThrow(() -> new IllegalArgumentException("账号不存在"));
    }
}
