package com.example.modernbbs.controller;

import com.example.modernbbs.model.User;
import com.example.modernbbs.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class PublicProfileController {
    private final UserService userService;

    public PublicProfileController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/users/{username}")
    public String publicProfile(@PathVariable String username, Model model) {
        User user = userService.findPublicByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("未找到该元老档案"));
        model.addAttribute("profileUser", user);
        return "public-profile";
    }
}
