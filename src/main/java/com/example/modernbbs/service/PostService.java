package com.example.modernbbs.service;

import com.example.modernbbs.model.Category;
import com.example.modernbbs.model.Comment;
import com.example.modernbbs.model.Post;
import com.example.modernbbs.model.User;
import com.example.modernbbs.repository.CommentRepository;
import com.example.modernbbs.repository.CommentReactionRepository;
import com.example.modernbbs.repository.PostRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.HashSet;
import java.util.Set;

@Service
public class PostService {
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;
    private final CommentReactionRepository commentReactionRepository;
    private final CategoryService categoryService;
    private final NotificationService notificationService;

    public PostService(PostRepository postRepository,
                       CommentRepository commentRepository,
                       CommentReactionRepository commentReactionRepository,
                       CategoryService categoryService,
                       NotificationService notificationService) {
        this.postRepository = postRepository;
        this.commentRepository = commentRepository;
        this.commentReactionRepository = commentReactionRepository;
        this.categoryService = categoryService;
        this.notificationService = notificationService;
    }

    public Page<Post> search(String keyword, Long categoryId, Pageable pageable) {
        String cleanKeyword = keyword == null || keyword.trim().isBlank() ? null : keyword.trim();
        return postRepository.search(cleanKeyword, categoryId, pageable);
    }

    public Page<Post> page(Pageable pageable) {
        return postRepository.findAll(pageable);
    }

    public long countPosts() {
        return postRepository.count();
    }

    public long countComments() {
        return commentRepository.count();
    }

    public List<Post> latest(int ignoredLimit) {
        return postRepository.findTop5ByOrderByUpdatedAtDesc();
    }

    public List<Comment> latestComments(int ignoredLimit) {
        return commentRepository.findTop5ByOrderByCreatedAtDesc();
    }

    public Page<Comment> commentsPage(Pageable pageable) {
        return commentRepository.findAllByOrderByCreatedAtDesc(pageable);
    }

    @Transactional
    public Post create(String title, String content, Long categoryId, User author) {
        title = clean(title);
        content = clean(content);
        if (title.length() < 3 || title.length() > 120) {
            throw new IllegalArgumentException("标题长度应为 3-120 个字符");
        }
        if (content.length() < 5) {
            throw new IllegalArgumentException("讨论正文至少 5 个字符");
        }
        Category category = categoryService.mustFind(categoryId);
        if (category.isExecutiveOnly() && !author.isExecutiveRepresentative()) {
            throw new IllegalArgumentException("该分区属于元老院正式公报区，仅执委会代表或管理员可以发布。普通元老可在其它分区发起讨论。 ");
        }
        Post post = new Post();
        post.setTitle(title);
        post.setContent(content);
        post.setCategory(category);
        post.setAuthor(author);
        post.setLastRepliedAt(LocalDateTime.now());
        return postRepository.save(post);
    }

    @Transactional
    public Post view(Long id) {
        Post post = mustFind(id);
        post.setViews(post.getViews() + 1);
        return post;
    }

    public Post mustFind(Long id) {
        return postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("讨论不存在"));
    }

    /**
     * B站式评论区：默认只取一级评论，楼中回复通过 childCommentsByParentId() 传给页面。
     */
    @Transactional(readOnly = true)
    public List<Comment> comments(Long postId) {
        return comments(postId, "oldest");
    }

    @Transactional(readOnly = true)
    public List<Comment> comments(Long postId, String sort) {
        String cleanSort = sort == null ? "oldest" : sort.trim().toLowerCase();
        return switch (cleanSort) {
            case "newest" -> commentRepository.findByPostIdAndParentIsNullOrderByCreatedAtDesc(postId);
            case "hot" -> commentRepository.findByPostIdAndParentIsNullOrderByLikeCountDescCreatedAtAsc(postId);
            default -> commentRepository.findByPostIdAndParentIsNullOrderByCreatedAtAsc(postId);
        };
    }

    /**
     * 返回 rootCommentId -> 楼中回复列表。
     *
     * B站式楼中楼的关键点：
     * 1. 数据库里保留“直接回复对象”，例如 A 回复 B，parent_id 就是 B；
     * 2. 页面渲染时统一把所有子回复归到一级评论下面，避免无限缩进；
     * 3. 子回复仍然能显示“回复 @某某”，语义不会丢。
     */
    @Transactional(readOnly = true)
    public Map<Long, List<Comment>> childCommentsByParentId(Long postId) {
        List<Comment> all = commentRepository.findByPostIdOrderByCreatedAtAsc(postId);
        Map<Long, List<Comment>> map = new LinkedHashMap<>();
        Map<Long, Comment> byId = new LinkedHashMap<>();
        for (Comment comment : all) {
            if (comment.getId() != null) {
                byId.put(comment.getId(), comment);
            }
        }
        for (Comment comment : all) {
            Comment parent = comment.getParent();
            if (parent == null || parent.getId() == null) {
                continue;
            }
            // 初始化直接回复对象，避免 Thymeleaf 渲染时懒加载失败。
            parent.getId();
            parent.getAuthor().getArchiveDisplayCode();

            Comment root = topLevelParent(parent, byId);
            if (root != null && root.getId() != null) {
                map.computeIfAbsent(root.getId(), ignored -> new ArrayList<>()).add(comment);
            }
        }
        return map;
    }

    private Comment topLevelParent(Comment parent, Map<Long, Comment> byId) {
        Comment current = parent;
        int guard = 0;
        while (current != null && current.getParent() != null && current.getParent().getId() != null && guard++ < 20) {
            Comment next = byId.get(current.getParent().getId());
            if (next == null) {
                next = current.getParent();
                next.getId();
            }
            current = next;
        }
        return current;
    }

    @Transactional
    public Comment addComment(Long postId, String content, User author) {
        return addComment(postId, content, author, null);
    }

    @Transactional
    public Comment addComment(Long postId, String content, User author, Long parentId) {
        content = clean(content);
        if (content.length() < 2) {
            throw new IllegalArgumentException("回复内容太短");
        }
        Post post = mustFind(postId);
        Comment parent = null;
        if (parentId != null) {
            parent = commentRepository.findById(parentId)
                    .orElseThrow(() -> new IllegalArgumentException("要回复的楼层不存在"));
            if (parent.getPost() == null || !post.getId().equals(parent.getPost().getId())) {
                throw new IllegalArgumentException("不能跨议案回复其它楼层");
            }
            // 保留直接回复对象：页面会统一归到一级评论下显示，
            // 但仍可显示“回复 @某某”，更接近 B 站评论区。
        }
        Comment comment = new Comment();
        comment.setPost(post);
        comment.setAuthor(author);
        comment.setContent(content);
        comment.setParent(parent);
        comment.setFloorNo(Math.toIntExact(post.getCommentCount() + 1));
        post.setCommentCount(post.getCommentCount() + 1);
        post.setLastRepliedAt(LocalDateTime.now());
        post.setUpdatedAt(LocalDateTime.now());
        Comment saved = commentRepository.save(comment);
        if (parent != null) {
            notificationService.notifyCommentReply(parent, saved);
        } else {
            notificationService.notifyPostReply(post, saved);
        }
        return saved;
    }

    @Transactional
    public boolean toggleCommentLike(Long commentId, User user) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("请先登录后再点赞");
        }
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("评论不存在"));
        var existing = commentReactionRepository.findByUserIdAndTargetTypeAndTargetIdAndReactionType(user.getId(), "COMMENT", commentId, "LIKE");
        boolean liked;
        if (existing.isPresent()) {
            commentReactionRepository.delete(existing.get());
            liked = false;
        } else {
            var reaction = new com.example.modernbbs.model.CommentReaction();
            reaction.setUser(user);
            reaction.setTargetType("COMMENT");
            reaction.setTargetId(commentId);
            reaction.setReactionType("LIKE");
            commentReactionRepository.save(reaction);
            notificationService.notifyCommentLike(comment, user);
            liked = true;
        }
        long count = commentReactionRepository.countByTargetTypeAndTargetIdAndReactionType("COMMENT", commentId, "LIKE");
        comment.setLikeCount(count);
        commentRepository.save(comment);
        return liked;
    }

    @Transactional(readOnly = true)
    public Set<Long> likedCommentIds(User user, List<Comment> roots, Map<Long, List<Comment>> children) {
        if (user == null || user.getId() == null) return Set.of();
        List<Long> ids = new ArrayList<>();
        if (roots != null) {
            for (Comment root : roots) if (root.getId() != null) ids.add(root.getId());
        }
        if (children != null) {
            for (List<Comment> list : children.values()) {
                for (Comment child : list) if (child.getId() != null) ids.add(child.getId());
            }
        }
        if (ids.isEmpty()) return Set.of();
        return new HashSet<>(commentReactionRepository.findLikedCommentIds(user.getId(), ids));
    }

    @Transactional
    public Post setPinned(Long postId, boolean pinned) {
        Post post = mustFind(postId);
        post.setPinned(pinned);
        return postRepository.save(post);
    }

    @Transactional
    public void deletePost(Long postId) {
        Post post = mustFind(postId);
        commentRepository.deleteByPostId(postId);
        postRepository.delete(post);
    }

    /**
     * 删除议案。管理员可以删除任何议案；作者本人可以删除自己的议案。
     */
    @Transactional
    public void deletePost(Long postId, User operator) {
        Post post = mustFind(postId);
        if (operator == null || operator.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        boolean isOwner = post.getAuthor() != null && operator.getId().equals(post.getAuthor().getId());
        if (!operator.isAdmin() && !isOwner) {
            throw new IllegalArgumentException("只能删除自己的议案；管理员可以删除所有议案。 ");
        }
        commentRepository.deleteByPostId(postId);
        postRepository.delete(post);
    }

    @Transactional
    public void deleteComment(Long commentId) {
        deleteComment(commentId, null);
    }

    /**
     * 删除评论。管理员可以删除任何评论；普通元老只能删除自己的评论。
     * 如果删除的是一级评论，会连同楼中回复一起删除，避免子回复被抬升成新的一级评论。
     */
    @Transactional
    public void deleteComment(Long commentId, User operator) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("回复不存在"));
        if (operator != null && !operator.isAdmin() && (comment.getAuthor() == null || !operator.getId().equals(comment.getAuthor().getId()))) {
            throw new IllegalArgumentException("只能删除自己的回复；管理员可以删除所有回复。");
        }
        Post post = comment.getPost();
        deleteCommentTree(comment);
        long count = commentRepository.countByPostId(post.getId());
        post.setCommentCount(count);
        post.setUpdatedAt(LocalDateTime.now());
        postRepository.save(post);
    }

    private void deleteCommentTree(Comment comment) {
        List<Comment> children = commentRepository.findByParentIdOrderByCreatedAtAsc(comment.getId());
        for (Comment child : children) {
            deleteCommentTree(child);
        }
        commentRepository.delete(comment);
        commentRepository.flush();
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}
