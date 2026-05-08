package com.example.modernbbs.controller;

import com.example.modernbbs.config.AuthInterceptor;
import com.example.modernbbs.model.PrivateMessage;
import com.example.modernbbs.model.User;
import com.example.modernbbs.service.PrivateMessageService;
import com.example.modernbbs.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/messages")
public class PrivateMessageController {
    private final PrivateMessageService privateMessageService;
    private final UserService userService;

    public PrivateMessageController(PrivateMessageService privateMessageService, UserService userService) {
        this.privateMessageService = privateMessageService;
        this.userService = userService;
    }

    @GetMapping
    public String inbox(HttpSession session, Model model) {
        User currentUser = currentUser(session);
        model.addAttribute("conversations", privateMessageService.conversations(currentUser));
        return "messages";
    }

    @GetMapping("/{username}")
    public String conversation(@PathVariable String username, HttpSession session, Model model) {
        User currentUser = currentUser(session);
        User other = privateMessageService.findRecipient(username);
        if (other.getId().equals(currentUser.getId())) {
            return "redirect:/profile";
        }
        List<PrivateMessage> messages = privateMessageService.conversationWith(currentUser, username);
        model.addAttribute("otherUser", other);
        model.addAttribute("messages", messages);
        model.addAttribute("conversations", privateMessageService.conversations(currentUser));
        return "conversation";
    }

    @PostMapping("/{username}")
    public String send(@PathVariable String username,
                       @RequestParam String content,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {
        User currentUser = currentUser(session);
        privateMessageService.send(currentUser, username, content);
        redirectAttributes.addFlashAttribute("success", "密信已送达");
        return "redirect:/messages/" + username + "#message-compose";
    }

    private User currentUser(HttpSession session) {
        Object id = session == null ? null : session.getAttribute(AuthInterceptor.LOGIN_USER_ID);
        if (!(id instanceof Long userId)) {
            throw new IllegalArgumentException("请先登入");
        }
        return userService.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("账号不存在"));
    }
}
