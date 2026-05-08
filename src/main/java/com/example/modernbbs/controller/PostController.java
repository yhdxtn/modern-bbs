package com.example.modernbbs.controller;

import com.example.modernbbs.config.AuthInterceptor;
import com.example.modernbbs.model.User;
import com.example.modernbbs.service.CategoryService;
import com.example.modernbbs.service.ContentRenderService;
import com.example.modernbbs.service.PostService;
import com.example.modernbbs.service.UploadService;
import com.example.modernbbs.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping("/posts")
public class PostController {
    private final PostService postService;
    private final CategoryService categoryService;
    private final UserService userService;
    private final UploadService uploadService;
    private final ContentRenderService contentRenderService;

    public PostController(PostService postService,
                          CategoryService categoryService,
                          UserService userService,
                          UploadService uploadService,
                          ContentRenderService contentRenderService) {
        this.postService = postService;
        this.categoryService = categoryService;
        this.userService = userService;
        this.uploadService = uploadService;
        this.contentRenderService = contentRenderService;
    }

    @GetMapping("/new")
    public String newPost(Model model) {
        model.addAttribute("categories", categoryService.all());
        return "post-form";
    }

    @PostMapping
    public String create(@RequestParam String title,
                         @RequestParam String content,
                         @RequestParam Long categoryId,
                         @RequestParam(required = false, name = "images") List<MultipartFile> images,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        User user = currentUser(session);
        try {
            String finalContent = appendUploadedImages(content, images);
            var post = postService.create(title, finalContent, categoryId, user);
            return "redirect:/posts/" + post.getId();
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            redirectAttributes.addFlashAttribute("title", title);
            redirectAttributes.addFlashAttribute("content", content);
            redirectAttributes.addFlashAttribute("categoryId", categoryId);
            return "redirect:/posts/new";
        }
    }

    @PostMapping("/images")
    @ResponseBody
    public Map<String, String> uploadInlineImage(@RequestParam("image") MultipartFile image,
                                                 HttpSession session) {
        currentUser(session);
        String url = uploadService.savePostImage(image);
        String original = image.getOriginalFilename() == null ? "议案图片" : image.getOriginalFilename().replaceAll("[\r\n]", " ");
        Map<String, String> result = new LinkedHashMap<>();
        result.put("url", url);
        result.put("name", original);
        result.put("markdown", "![" + original + "](" + url + ")");
        return result;
    }

    @GetMapping("/{id}/jump")
    public String jump(@PathVariable Long id, Model model) {
        var post = postService.view(id);
        model.addAttribute("post", post);
        return "post-jump";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id,
                         @RequestParam(required = false, defaultValue = "oldest") String commentSort,
                         HttpSession session,
                         Model model) {
        var post = postService.view(id);
        var comments = postService.comments(id, commentSort);
        var childCommentsByParentId = postService.childCommentsByParentId(id);
        User viewer = optionalCurrentUser(session);
        Set<Long> likedCommentIds = postService.likedCommentIds(viewer, comments, childCommentsByParentId);
        Map<Long, String> renderedCommentContentById = new LinkedHashMap<>();
        for (var comment : comments) {
            renderedCommentContentById.put(comment.getId(), contentRenderService.render(comment.getContent()));
        }
        for (var replies : childCommentsByParentId.values()) {
            for (var reply : replies) {
                renderedCommentContentById.put(reply.getId(), contentRenderService.render(reply.getContent()));
            }
        }
        model.addAttribute("post", post);
        model.addAttribute("renderedContent", contentRenderService.render(post.getContent()));
        model.addAttribute("comments", comments);
        model.addAttribute("childCommentsByParentId", childCommentsByParentId);
        model.addAttribute("renderedCommentContentById", renderedCommentContentById);
        model.addAttribute("likedCommentIds", likedCommentIds);
        model.addAttribute("commentSort", commentSort == null ? "oldest" : commentSort);
        return "post-detail";
    }

    @PostMapping("/{id}/comments")
    public String comment(@PathVariable Long id,
                          @RequestParam String content,
                          @RequestParam(required = false) Long parentId,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        User user = currentUser(session);
        try {
            postService.addComment(id, content, user, parentId);
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/posts/" + id + "#comments";
    }

    @PostMapping("/{postId}/comments/{commentId}/like")
    public String likeComment(@PathVariable Long postId,
                              @PathVariable Long commentId,
                              @RequestParam(required = false, defaultValue = "oldest") String commentSort,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = currentUser(session);
        try {
            postService.toggleCommentLike(commentId, user);
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/posts/" + postId + "?commentSort=" + commentSort + "#comment-" + commentId;
    }

    @PostMapping("/{postId}/comments/{commentId}/delete")
    public String deleteCommentFromThread(@PathVariable Long postId,
                                          @PathVariable Long commentId,
                                          HttpSession session,
                                          RedirectAttributes redirectAttributes) {
        User user = currentUser(session);
        try {
            postService.deleteComment(commentId, user);
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/posts/" + postId + "#comments";
    }

    @PostMapping("/{id}/delete")
    public String deletePostFromDetail(@PathVariable Long id,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        User user = currentUser(session);
        try {
            postService.deletePost(id, user);
            redirectAttributes.addFlashAttribute("success", "议案已删除");
            return "redirect:/";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/posts/" + id;
        }
    }


    private String appendUploadedImages(String content, List<MultipartFile> images) {
        StringBuilder builder = new StringBuilder(content == null ? "" : content.trim());
        if (images == null || images.isEmpty()) {
            return builder.toString();
        }
        for (MultipartFile image : images) {
            if (image == null || image.isEmpty()) continue;
            String url = uploadService.savePostImage(image);
            String original = image.getOriginalFilename() == null ? "议案图片" : image.getOriginalFilename().replaceAll("[\\r\\n]", " ");
            builder.append("\n\n![").append(original).append("](").append(url).append(")");
        }
        return builder.toString();
    }

    private User optionalCurrentUser(HttpSession session) {
        Object id = session == null ? null : session.getAttribute(AuthInterceptor.LOGIN_USER_ID);
        if (id instanceof Long userId) {
            return userService.findById(userId).orElse(null);
        }
        return null;
    }

    private User currentUser(HttpSession session) {
        Object id = session.getAttribute(AuthInterceptor.LOGIN_USER_ID);
        if (!(id instanceof Long userId)) {
            throw new IllegalArgumentException("请先登录");
        }
        return userService.findById(userId).orElseThrow(() -> new IllegalArgumentException("账号不存在"));
    }
}
