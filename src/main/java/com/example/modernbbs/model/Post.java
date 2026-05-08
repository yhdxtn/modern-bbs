package com.example.modernbbs.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bbs_threads", indexes = {
        @Index(name = "idx_thread_category_updated", columnList = "category_id, pinned, updated_at"),
        @Index(name = "idx_thread_author", columnList = "author_id, created_at"),
        @Index(name = "idx_thread_created_at", columnList = "created_at"),
        @Index(name = "idx_thread_updated_at", columnList = "updated_at"),
        @Index(name = "idx_thread_status", columnList = "status"),
        @Index(name = "idx_thread_title", columnList = "title")
})
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 160)
    private String title;

    @OneToOne(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER, optional = false)
    private PostContent contentEntity;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "author_id")
    private User author;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(name = "view_count", nullable = false)
    private Long views = 0L;

    @Column(name = "comment_count", nullable = false)
    private Long commentCount = 0L;

    @Column(name = "like_count", nullable = false)
    private Long likeCount = 0L;

    @Column(nullable = false)
    private Boolean pinned = false;

    @Column(nullable = false, length = 20)
    private String status = "PUBLISHED";

    @Column(name = "last_replied_at")
    private LocalDateTime lastRepliedAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (createdAt == null) createdAt = now;
        if (updatedAt == null) updatedAt = now;
        if (lastRepliedAt == null) lastRepliedAt = now;
        if (views == null) views = 0L;
        if (commentCount == null) commentCount = 0L;
        if (likeCount == null) likeCount = 0L;
        if (pinned == null) pinned = false;
        if (status == null || status.isBlank()) status = "PUBLISHED";
        if (contentEntity != null) contentEntity.setPost(this);
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return contentEntity == null ? "" : contentEntity.getContent(); }
    public void setContent(String content) {
        if (this.contentEntity == null) {
            this.contentEntity = new PostContent();
            this.contentEntity.setPost(this);
        }
        this.contentEntity.setContent(content);
    }
    public PostContent getContentEntity() { return contentEntity; }
    public void setContentEntity(PostContent contentEntity) {
        this.contentEntity = contentEntity;
        if (contentEntity != null) contentEntity.setPost(this);
    }
    public User getAuthor() { return author; }
    public void setAuthor(User author) { this.author = author; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public Long getViews() { return views; }
    public void setViews(Long views) { this.views = views; }
    public Long getCommentCount() { return commentCount; }
    public void setCommentCount(Long commentCount) { this.commentCount = commentCount; }
    public Long getLikeCount() { return likeCount; }
    public void setLikeCount(Long likeCount) { this.likeCount = likeCount; }
    public Boolean getPinned() { return pinned; }
    public void setPinned(Boolean pinned) { this.pinned = pinned; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getLastRepliedAt() { return lastRepliedAt; }
    public void setLastRepliedAt(LocalDateTime lastRepliedAt) { this.lastRepliedAt = lastRepliedAt; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
