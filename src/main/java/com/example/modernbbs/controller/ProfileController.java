package com.example.modernbbs.controller;

import com.example.modernbbs.config.AuthInterceptor;
import com.example.modernbbs.model.User;
import com.example.modernbbs.service.UploadService;
import com.example.modernbbs.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ProfileController {
    private final UserService userService;
    private final UploadService uploadService;

    public ProfileController(UserService userService, UploadService uploadService) {
        this.userService = userService;
        this.uploadService = uploadService;
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = currentUser(session);
        model.addAttribute("profileUser", user);
        return "profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@RequestParam String nickname,
                                @RequestParam(required = false) String avatarUrl,
                                @RequestParam(required = false) MultipartFile avatarFile,
                                @RequestParam(required = false) String bio,
                                @RequestParam(required = false) String councilDepartment,
                                @RequestParam(required = false) String specialty,
                                @RequestParam(required = false) String callSign,
                                @RequestParam(required = false) String telegramCode,
                                @RequestParam(defaultValue = "STRATEGIC") String stationScope,
                                @RequestParam(required = false) String stationName,
                                @RequestParam(defaultValue = "1") Integer stationElderCount,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            User user = currentUser(session);
            String finalAvatarUrl = avatarUrl;
            if (avatarFile != null && !avatarFile.isEmpty()) {
                finalAvatarUrl = uploadService.saveAvatarImage(avatarFile);
            }
            userService.updateProfile(user.getId(), nickname, finalAvatarUrl, bio, councilDepartment, specialty, callSign, telegramCode, stationScope, stationName, stationElderCount);
            redirectAttributes.addFlashAttribute("success", "个人档案已更新");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/profile#profile-form";
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
