package com.example.modernbbs.controller;

import com.example.modernbbs.config.AuthInterceptor;
import com.example.modernbbs.model.User;
import com.example.modernbbs.service.CategoryService;
import com.example.modernbbs.service.UserService;
import com.example.modernbbs.service.DepartmentBannerService;
import com.example.modernbbs.service.PrivateMessageService;
import com.example.modernbbs.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

@ControllerAdvice
public class GlobalControllerAdvice {
    private final UserService userService;
    private final CategoryService categoryService;
    private final DepartmentBannerService departmentBannerService;
    private final PrivateMessageService privateMessageService;
    private final NotificationService notificationService;

    public GlobalControllerAdvice(UserService userService, CategoryService categoryService, DepartmentBannerService departmentBannerService, PrivateMessageService privateMessageService, NotificationService notificationService) {
        this.userService = userService;
        this.categoryService = categoryService;
        this.departmentBannerService = departmentBannerService;
        this.privateMessageService = privateMessageService;
        this.notificationService = notificationService;
    }

    @ModelAttribute
    public void common(Model model, HttpSession session) {
        Object id = session == null ? null : session.getAttribute(AuthInterceptor.LOGIN_USER_ID);
        User currentUser = null;
        if (id instanceof Long userId) {
            currentUser = userService.findById(userId).orElse(null);
        }
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("canManageDepartmentBanners", departmentBannerService.canManageAny(currentUser));
        long privateUnread = currentUser == null ? 0L : privateMessageService.unreadCount(currentUser);
        long notificationUnread = currentUser == null ? 0L : notificationService.unreadCount(currentUser);
        model.addAttribute("privateUnreadCount", privateUnread);
        model.addAttribute("notificationUnreadCount", notificationUnread);
        model.addAttribute("totalUnreadCount", privateUnread + notificationUnread);
        model.addAttribute("navCategories", categoryService.all());
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String badRequest(IllegalArgumentException ex, Model model) {
        model.addAttribute("message", ex.getMessage());
        return "error";
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public String uploadTooLarge(MaxUploadSizeExceededException ex, Model model) {
        model.addAttribute("message", "上传图片过大。头像和帖子图片建议压缩到 50MB 以内；如果仍然报 413，请检查 application.yml 里的 multipart 限制或前置 Nginx 限制。");
        return "error";
    }
}
