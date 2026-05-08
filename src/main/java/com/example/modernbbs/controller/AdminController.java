package com.example.modernbbs.controller;

import com.example.modernbbs.model.Category;
import com.example.modernbbs.service.CategoryService;
import com.example.modernbbs.service.DashboardService;
import com.example.modernbbs.service.PostService;
import com.example.modernbbs.service.UserService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private final UserService userService;
    private final PostService postService;
    private final CategoryService categoryService;
    private final DashboardService dashboardService;

    public AdminController(UserService userService,
                           PostService postService,
                           CategoryService categoryService,
                           DashboardService dashboardService) {
        this.userService = userService;
        this.postService = postService;
        this.categoryService = categoryService;
        this.dashboardService = dashboardService;
    }

    @GetMapping
    public String index() {
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("userCount", userService.count());
        model.addAttribute("postCount", postService.countPosts());
        model.addAttribute("commentCount", postService.countComments());
        model.addAttribute("categoryCount", categoryService.count());
        model.addAttribute("adminCount", userService.countAdmins());
        model.addAttribute("latestPosts", postService.latest(5));
        model.addAttribute("latestComments", postService.latestComments(5));
        model.addAttribute("worldElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_WORLD));
        model.addAttribute("chinaElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_CHINA));
        model.addAttribute("strategicElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_STRATEGIC));
        model.addAttribute("newWorldBaseDateTime", dashboardService.getNewWorldBaseDateTime());
        return "admin/dashboard";
    }

    @GetMapping("/command")
    public String command(Model model) {
        model.addAttribute("newWorldLabel", dashboardService.getNewWorldLabel());
        model.addAttribute("newWorldDateTimeInput", dashboardService.getNewWorldDateTimeInputValue());
        model.addAttribute("newWorldBaseDateTime", dashboardService.getNewWorldBaseDateTime());
        model.addAttribute("newWorldSyncEpochMillis", dashboardService.getNewWorldSyncEpochMillis());
        model.addAttribute("worldLocations", dashboardService.allLocations(DashboardService.SCOPE_WORLD));
        model.addAttribute("chinaLocations", dashboardService.allLocations(DashboardService.SCOPE_CHINA));
        model.addAttribute("strategicLocations", dashboardService.allLocations(DashboardService.SCOPE_STRATEGIC));
        model.addAttribute("worldElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_WORLD));
        model.addAttribute("chinaElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_CHINA));
        model.addAttribute("strategicElderTotal", dashboardService.totalVisible(DashboardService.SCOPE_STRATEGIC));
        return "admin/command";
    }

    @PostMapping("/command/time")
    public String updateCommandTime(@RequestParam String newWorldDateTime,
                                    @RequestParam(required = false) String label,
                                    RedirectAttributes redirectAttributes) {
        try {
            dashboardService.updateNewWorldTime(newWorldDateTime, label);
            redirectAttributes.addFlashAttribute("success", "新世界时间已保存，首页会从这个时间继续走秒");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/command";
    }

    @PostMapping("/command/locations")
    public String createCommandLocation(@RequestParam String scope,
                                        @RequestParam String name,
                                        @RequestParam(defaultValue = "0") Integer value,
                                        @RequestParam(defaultValue = "0") Integer sortOrder,
                                        @RequestParam(defaultValue = "false") boolean visible,
                                        RedirectAttributes redirectAttributes) {
        try {
            dashboardService.createLocation(scope, name, value, sortOrder, visible);
            redirectAttributes.addFlashAttribute("success", "元老驻点已新增");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/command";
    }

    @PostMapping("/command/locations/{id}")
    public String updateCommandLocation(@PathVariable Long id,
                                        @RequestParam String scope,
                                        @RequestParam String name,
                                        @RequestParam(defaultValue = "0") Integer value,
                                        @RequestParam(defaultValue = "0") Integer sortOrder,
                                        @RequestParam(defaultValue = "false") boolean visible,
                                        RedirectAttributes redirectAttributes) {
        try {
            dashboardService.updateLocation(id, scope, name, value, sortOrder, visible);
            redirectAttributes.addFlashAttribute("success", "元老驻点已更新");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/command";
    }

    @PostMapping("/command/locations/{id}/delete")
    public String deleteCommandLocation(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            dashboardService.deleteLocation(id);
            redirectAttributes.addFlashAttribute("success", "元老驻点已删除");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/command";
    }

    @GetMapping("/users")
    public String users(@RequestParam(defaultValue = "0") int page, Model model) {
        Pageable pageable = PageRequest.of(Math.max(page, 0), 15, Sort.by(Sort.Direction.DESC, "createdAt"));
        model.addAttribute("users", userService.page(pageable));
        return "admin/users";
    }

    @PostMapping("/users/{id}/role")
    public String changeUserRole(@PathVariable Long id,
                                 @RequestParam String role,
                                 RedirectAttributes redirectAttributes) {
        try {
            userService.changeRole(id, role);
            redirectAttributes.addFlashAttribute("success", "身份权限已更新");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/users/{id}/edit")
    public String editUser(@PathVariable Long id, Model model) {
        model.addAttribute("user", userService.findById(id).orElseThrow(() -> new IllegalArgumentException("账号不存在")));
        return "admin/user-form";
    }

    @PostMapping("/users/{id}")
    public String updateUser(@PathVariable Long id,
                             @RequestParam String nickname,
                             @RequestParam(required = false) String avatarUrl,
                             @RequestParam(required = false) String bio,
                             @RequestParam(required = false) String councilDepartment,
                             @RequestParam(required = false) String specialty,
                             @RequestParam(required = false) String callSign,
                             @RequestParam(required = false) String telegramCode,
                             @RequestParam(required = false) String stationScope,
                             @RequestParam(required = false) String stationName,
                             @RequestParam(required = false) Integer stationElderCount,
                             @RequestParam String role,
                             @RequestParam String status,
                             @RequestParam(required = false) String newPassword,
                             RedirectAttributes redirectAttributes) {
        try {
            userService.adminUpdateUser(id, nickname, avatarUrl, bio, councilDepartment, specialty,
                    callSign, telegramCode, stationScope, stationName, stationElderCount, role, status, newPassword);
            redirectAttributes.addFlashAttribute("success", "元老档案已更新");
            return "redirect:/admin/users";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/users/" + id + "/edit";
        }
    }


    @GetMapping("/posts")
    public String posts(@RequestParam(defaultValue = "0") int page, Model model) {
        Pageable pageable = PageRequest.of(Math.max(page, 0), 12, Sort.by(Sort.Direction.DESC, "updatedAt"));
        model.addAttribute("posts", postService.page(pageable));
        return "admin/posts";
    }

    @PostMapping("/posts/{id}/pin")
    public String pinPost(@PathVariable Long id,
                          @RequestParam(defaultValue = "false") boolean pinned,
                          RedirectAttributes redirectAttributes) {
        try {
            postService.setPinned(id, pinned);
            redirectAttributes.addFlashAttribute("success", pinned ? "议案已置顶" : "议案已取消置顶");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/posts";
    }

    @PostMapping("/posts/{id}/delete")
    public String deletePost(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            postService.deletePost(id);
            redirectAttributes.addFlashAttribute("success", "议案已删除");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/posts";
    }

    @GetMapping("/comments")
    public String comments(@RequestParam(defaultValue = "0") int page, Model model) {
        Pageable pageable = PageRequest.of(Math.max(page, 0), 15, Sort.by(Sort.Direction.DESC, "createdAt"));
        model.addAttribute("comments", postService.commentsPage(pageable));
        return "admin/comments";
    }

    @PostMapping("/comments/{id}/delete")
    public String deleteComment(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            postService.deleteComment(id);
            redirectAttributes.addFlashAttribute("success", "回复已删除");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/comments";
    }

    @GetMapping("/categories")
    public String categories(Model model) {
        model.addAttribute("categories", categoryService.all());
        return "admin/categories";
    }

    @GetMapping("/categories/new")
    public String newCategory(Model model) {
        model.addAttribute("category", new Category());
        model.addAttribute("mode", "create");
        return "admin/category-form";
    }

    @PostMapping("/categories")
    public String createCategory(@RequestParam String name,
                                 @RequestParam String slug,
                                 @RequestParam(required = false) String description,
                                 @RequestParam(defaultValue = "0") Integer sortOrder,
                                 @RequestParam(defaultValue = "false") boolean executiveOnly,
                                 @RequestParam(required = false) String managerUsername,
                                 RedirectAttributes redirectAttributes) {
        try {
            categoryService.create(name, slug, description, sortOrder, executiveOnly, managerUsername);
            redirectAttributes.addFlashAttribute("success", "分区已创建");
            return "redirect:/admin/categories";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/categories/new";
        }
    }

    @GetMapping("/categories/{id}/edit")
    public String editCategory(@PathVariable Long id, Model model) {
        model.addAttribute("category", categoryService.mustFind(id));
        model.addAttribute("mode", "edit");
        return "admin/category-form";
    }

    @PostMapping("/categories/{id}")
    public String updateCategory(@PathVariable Long id,
                                 @RequestParam String name,
                                 @RequestParam String slug,
                                 @RequestParam(required = false) String description,
                                 @RequestParam(defaultValue = "0") Integer sortOrder,
                                 @RequestParam(defaultValue = "false") boolean executiveOnly,
                                 @RequestParam(required = false) String managerUsername,
                                 RedirectAttributes redirectAttributes) {
        try {
            categoryService.update(id, name, slug, description, sortOrder, executiveOnly, managerUsername);
            redirectAttributes.addFlashAttribute("success", "分区已更新");
            return "redirect:/admin/categories";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/categories/" + id + "/edit";
        }
    }

    @PostMapping("/categories/{id}/delete")
    public String deleteCategory(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            categoryService.delete(id);
            redirectAttributes.addFlashAttribute("success", "分区已删除");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/categories";
    }
}
