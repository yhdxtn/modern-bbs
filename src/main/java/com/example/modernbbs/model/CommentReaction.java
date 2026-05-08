package com.example.modernbbs.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bbs_reactions",
       uniqueConstraints = @UniqueConstraint(name = "uk_reaction_once", columnNames = {"user_id", "target_type", "target_id", "reaction_type"}),
       indexes = {
           @Index(name = "idx_reaction_user", columnList = "user_id"),
           @Index(name = "idx_reaction_target", columnList = "target_type, target_id")
       })
public class CommentReaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "target_type", nullable = false, length = 20)
    private String targetType = "COMMENT";

    @Column(name = "target_id", nullable = false)
    private Long targetId;

    @Column(name = "reaction_type", nullable = false, length = 20)
    private String reactionType = "LIKE";

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (targetType == null || targetType.isBlank()) targetType = "COMMENT";
        if (reactionType == null || reactionType.isBlank()) reactionType = "LIKE";
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getTargetType() { return targetType; }
    public void setTargetType(String targetType) { this.targetType = targetType; }
    public Long getTargetId() { return targetId; }
    public void setTargetId(Long targetId) { this.targetId = targetId; }
    public String getReactionType() { return reactionType; }
    public void setReactionType(String reactionType) { this.reactionType = reactionType; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
