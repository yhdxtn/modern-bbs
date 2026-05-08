package com.example.modernbbs.controller;

import com.example.modernbbs.config.AuthInterceptor;
import com.example.modernbbs.model.User;
import com.example.modernbbs.service.DepartmentBannerService;
import com.example.modernbbs.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/department/banners")
public class DepartmentBannerController {
    private final DepartmentBannerService bannerService;
    private final UserService userService;

    public DepartmentBannerController(DepartmentBannerService bannerService, UserService userService) {
        this.bannerService = bannerService;
        this.userService = userService;
    }

    @GetMapping
    public String index(Model model, HttpSession session) {
        User currentUser = currentUser(session);
        if (!bannerService.canManageAny(currentUser)) {
            model.addAttribute("message", "只有分区负责人或管理员可以维护部门宣传图");
            return "error";
        }
        model.addAttribute("banners", bannerService.manageableBanners(currentUser));
        model.addAttribute("manageableCategories", bannerService.manageableCategories(currentUser));
        return "department-banners";
    }

    @PostMapping
    public String create(@RequestParam Long categoryId,
                         @RequestParam String title,
                         @RequestParam(required = false) String subtitle,
                         @RequestParam(required = false) String imageUrl,
                         @RequestParam(required = false) MultipartFile imageFile,
                         @RequestParam(required = false) String linkText,
                         @RequestParam(required = false) String linkUrl,
                         @RequestParam(defaultValue = "0") Integer sortOrder,
                         @RequestParam(defaultValue = "false") boolean visible,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        try {
            bannerService.create(currentUser(session), categoryId, title, subtitle, imageUrl, imageFile, linkText, linkUrl, sortOrder, visible);
            redirectAttributes.addFlashAttribute("success", "宣传图已新增");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/department/banners";
    }

    @PostMapping("/{id}")
    public String update(@PathVariable Long id,
                         @RequestParam Long categoryId,
                         @RequestParam String title,
                         @RequestParam(required = false) String subtitle,
                         @RequestParam(required = false) String imageUrl,
                         @RequestParam(required = false) MultipartFile imageFile,
                         @RequestParam(required = false) String linkText,
                         @RequestParam(required = false) String linkUrl,
                         @RequestParam(defaultValue = "0") Integer sortOrder,
                         @RequestParam(defaultValue = "false") boolean visible,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        try {
            bannerService.update(currentUser(session), id, categoryId, title, subtitle, imageUrl, imageFile, linkText, linkUrl, sortOrder, visible);
            redirectAttributes.addFlashAttribute("success", "宣传图已更新");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/department/banners";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        try {
            bannerService.delete(currentUser(session), id);
            redirectAttributes.addFlashAttribute("success", "宣传图已删除");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/department/banners";
    }

    private User currentUser(HttpSession session) {
        Object id = session == null ? null : session.getAttribute(AuthInterceptor.LOGIN_USER_ID);
        if (id instanceof Long userId) {
            return userService.findById(userId).orElse(null);
        }
        return null;
    }
}
