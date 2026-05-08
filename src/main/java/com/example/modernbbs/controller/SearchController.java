package com.example.modernbbs.controller;

import com.example.modernbbs.repository.CommentRepository;
import com.example.modernbbs.service.PostService;
import com.example.modernbbs.service.UserService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SearchController {
    private final PostService postService;
    private final UserService userService;
    private final CommentRepository commentRepository;

    public SearchController(PostService postService, UserService userService, CommentRepository commentRepository) {
        this.postService = postService;
        this.userService = userService;
        this.commentRepository = commentRepository;
    }

    @GetMapping("/search")
    public String search(@RequestParam(required = false) String q,
                         @RequestParam(defaultValue = "0") int page,
                         Model model) {
        String keyword = q == null ? "" : q.trim();
        int safePage = Math.max(page, 0);
        Pageable pageable = PageRequest.of(safePage, 10);

        if (keyword.isBlank()) {
            model.addAttribute("q", "");
            model.addAttribute("posts", org.springframework.data.domain.Page.empty(pageable));
            model.addAttribute("users", org.springframework.data.domain.Page.empty(pageable));
            model.addAttribute("comments", org.springframework.data.domain.Page.empty(pageable));
            model.addAttribute("totalResults", 0L);
            return "search";
        }

        var posts = postService.search(keyword, null, pageable);
        var users = userService.searchPublic(keyword, pageable);
        var comments = commentRepository.searchPublic(keyword, pageable);

        model.addAttribute("q", keyword);
        model.addAttribute("posts", posts);
        model.addAttribute("users", users);
        model.addAttribute("comments", comments);
        model.addAttribute("totalResults", posts.getTotalElements() + users.getTotalElements() + comments.getTotalElements());
        return "search";
    }
}
