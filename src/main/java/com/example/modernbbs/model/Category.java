package com.example.modernbbs.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bbs_categories", indexes = {
        @Index(name = "idx_category_slug", columnList = "slug", unique = true),
        @Index(name = "idx_category_parent_sort", columnList = "parent_id, sort_order"),
        @Index(name = "idx_category_status", columnList = "status")
})
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Category parent;

    @Column(nullable = false, length = 40)
    private String name;

    @Column(nullable = false, unique = true, length = 40)
    private String slug;

    @Column(length = 500)
    private String description;

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 0;

    @Column(nullable = false, length = 20)
    private String status = "ACTIVE";

    /** 是否只允许执委会代表或管理员发帖，适合“元老院公告 / 执委会公报”这类正式分区。 */
    @Column(name = "executive_only", nullable = false, columnDefinition = "BIT DEFAULT 0")
    private Boolean executiveOnly = false;

    /** 分区负责人。负责人可维护该分区前台宣传图轮播。 */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "manager_user_id")
    private User managerUser;

    @Column(name = "thread_count", nullable = false)
    private Long threadCount = 0L;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (createdAt == null) createdAt = now;
        if (updatedAt == null) updatedAt = now;
        if (status == null || status.isBlank()) status = "ACTIVE";
        if (executiveOnly == null) executiveOnly = false;
        if (threadCount == null) threadCount = 0L;
        if (sortOrder == null) sortOrder = 0;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Category getParent() { return parent; }
    public void setParent(Category parent) { this.parent = parent; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Boolean getExecutiveOnly() { return executiveOnly; }
    public void setExecutiveOnly(Boolean executiveOnly) { this.executiveOnly = executiveOnly; }
    public boolean isExecutiveOnly() { return Boolean.TRUE.equals(executiveOnly); }
    public User getManagerUser() { return managerUser; }
    public void setManagerUser(User managerUser) { this.managerUser = managerUser; }
    public String getManagerDisplayCode() { return managerUser == null ? "未指定" : managerUser.getArchiveDisplayCode(); }
    public Long getThreadCount() { return threadCount; }
    public void setThreadCount(Long threadCount) { this.threadCount = threadCount; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
