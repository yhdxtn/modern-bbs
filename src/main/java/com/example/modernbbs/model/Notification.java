package com.example.modernbbs.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bbs_notifications", indexes = {
        @Index(name = "idx_notification_user_read_created", columnList = "user_id, read_at, created_at"),
        @Index(name = "idx_notification_target", columnList = "target_type, target_id")
})
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 40)
    private String type;

    @Column(nullable = false, length = 160)
    private String title;

    @Column(length = 500)
    private String content;

    @Column(name = "target_type", length = 20)
    private String targetType;

    @Column(name = "target_id")
    private Long targetId;

    @Column(name = "read_at")
    private LocalDateTime readAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getTargetType() { return targetType; }
    public void setTargetType(String targetType) { this.targetType = targetType; }
    public Long getTargetId() { return targetId; }
    public void setTargetId(Long targetId) { this.targetId = targetId; }
    public LocalDateTime getReadAt() { return readAt; }
    public void setReadAt(LocalDateTime readAt) { this.readAt = readAt; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isUnread() { return readAt == null; }

    public String getTypeLabel() {
        if ("PRIVATE_MESSAGE".equalsIgnoreCase(type)) return "私信";
        if ("COMMENT_REPLY".equalsIgnoreCase(type)) return "评论回复";
        if ("POST_REPLY".equalsIgnoreCase(type)) return "议案回复";
        if ("COMMENT_LIKE".equalsIgnoreCase(type)) return "评论点赞";
        return "通知";
    }

    public String getTargetUrl() {
        if ("MESSAGES".equalsIgnoreCase(targetType)) return "/messages";
        if (targetType == null || targetId == null) return "/notifications";
        if ("POST".equalsIgnoreCase(targetType)) return "/posts/" + targetId + "#comments";
        if ("COMMENT".equalsIgnoreCase(targetType)) return "/posts/" + targetId + "#comments";
        return "/notifications";
    }
}
