package com.example.modernbbs.service;

import com.example.modernbbs.model.Comment;
import com.example.modernbbs.model.Notification;
import com.example.modernbbs.model.Post;
import com.example.modernbbs.model.PrivateMessage;
import com.example.modernbbs.model.User;
import com.example.modernbbs.repository.NotificationRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class NotificationService {
    private final NotificationRepository notificationRepository;

    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public long unreadCount(User user) {
        if (user == null || user.getId() == null) return 0L;
        return notificationRepository.countByUserIdAndReadAtIsNull(user.getId());
    }

    public List<Notification> latest(User user) {
        if (user == null || user.getId() == null) return List.of();
        return notificationRepository.findByUserIdOrderByCreatedAtDesc(user.getId(), PageRequest.of(0, 80));
    }

    @Transactional
    public void markAllRead(User user) {
        if (user == null || user.getId() == null) return;
        notificationRepository.markAllRead(user.getId(), LocalDateTime.now());
    }

    @Transactional
    public void markRead(Long id, User user) {
        if (user == null || user.getId() == null || id == null) return;
        notificationRepository.findById(id).ifPresent(notification -> {
            if (notification.getUser() != null && user.getId().equals(notification.getUser().getId()) && notification.getReadAt() == null) {
                notification.setReadAt(LocalDateTime.now());
                notificationRepository.save(notification);
            }
        });
    }

    @Transactional
    public void notifyPostReply(Post post, Comment comment) {
        if (post == null || comment == null || post.getAuthor() == null || comment.getAuthor() == null) return;
        if (sameUser(post.getAuthor(), comment.getAuthor())) return;
        String title = comment.getAuthor().getDisplayName() + " 回复了你的议案";
        String content = excerpt(comment.getContent());
        create(post.getAuthor(), "POST_REPLY", title, content, "POST", post.getId());
    }

    @Transactional
    public void notifyCommentReply(Comment parent, Comment reply) {
        if (parent == null || reply == null || parent.getAuthor() == null || reply.getAuthor() == null) return;
        if (sameUser(parent.getAuthor(), reply.getAuthor())) return;
        String title = reply.getAuthor().getDisplayName() + " 回复了你的评论";
        String content = excerpt(reply.getContent());
        Long postId = reply.getPost() == null ? null : reply.getPost().getId();
        create(parent.getAuthor(), "COMMENT_REPLY", title, content, "POST", postId);
    }

    @Transactional
    public void notifyCommentLike(Comment comment, User actor) {
        if (comment == null || actor == null || comment.getAuthor() == null) return;
        if (sameUser(comment.getAuthor(), actor)) return;
        String title = actor.getDisplayName() + " 赞同了你的评论";
        String content = excerpt(comment.getContent());
        Long postId = comment.getPost() == null ? null : comment.getPost().getId();
        create(comment.getAuthor(), "COMMENT_LIKE", title, content, "POST", postId);
    }

    @Transactional
    public void notifyPrivateMessage(PrivateMessage message) {
        if (message == null || message.getRecipient() == null || message.getSender() == null) return;
        if (sameUser(message.getRecipient(), message.getSender())) return;
        String title = message.getSender().getDisplayName() + " 给你发来私信";
        create(message.getRecipient(), "PRIVATE_MESSAGE", title, excerpt(message.getContent()), "MESSAGES", null);
    }

    @Transactional
    public Notification create(User recipient, String type, String title, String content, String targetType, Long targetId) {
        if (recipient == null || recipient.getId() == null) return null;
        Notification notification = new Notification();
        notification.setUser(recipient);
        notification.setType(blankTo(type, "SYSTEM"));
        notification.setTitle(limit(blankTo(title, "新通知"), 160));
        notification.setContent(limit(content == null ? "" : content, 500));
        notification.setTargetType(targetType);
        notification.setTargetId(targetId);
        return notificationRepository.save(notification);
    }

    private boolean sameUser(User a, User b) {
        return a != null && b != null && a.getId() != null && a.getId().equals(b.getId());
    }

    private String excerpt(String value) {
        String clean = (value == null ? "" : value)
                .replaceAll("!\\[[^]]*]\\([^)]*\\)", "[图片]")
                .replaceAll("\\s+", " ")
                .trim();
        return limit(clean, 160);
    }

    private String limit(String value, int max) {
        if (value == null) return "";
        return value.length() <= max ? value : value.substring(0, max - 1) + "…";
    }

    private String blankTo(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }
}
