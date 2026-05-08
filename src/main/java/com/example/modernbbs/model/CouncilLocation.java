package com.example.modernbbs.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bbs_council_locations",
        uniqueConstraints = @UniqueConstraint(name = "uk_council_location_scope_name", columnNames = {"scope", "name"}),
        indexes = {
                @Index(name = "idx_council_location_scope_sort", columnList = "scope, sort_order"),
                @Index(name = "idx_council_location_visible", columnList = "visible")
        })
public class CouncilLocation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** WORLD = 全球地图；CHINA = 中国省份地图 */
    @Column(nullable = false, length = 20)
    private String scope;

    /** 必须与 ECharts 地图区域名称一致，例如 China、United States、广东、北京。 */
    @Column(nullable = false, length = 120)
    private String name;

    @Column(name = "elder_count", nullable = false, columnDefinition = "INT DEFAULT 0")
    private Integer value = 0;

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 0;

    @Column(nullable = false)
    private Boolean visible = true;

    @Column(name = "updated_at", nullable = false, columnDefinition = "DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    private LocalDateTime updatedAt;

    @PrePersist
    @PreUpdate
    void touch() {
        updatedAt = LocalDateTime.now();
        if (value == null) value = 0;
        if (sortOrder == null) sortOrder = 0;
        if (visible == null) visible = true;
        if (scope != null) scope = scope.trim().toUpperCase();
        if (name != null) name = name.trim();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getScope() { return scope; }
    public void setScope(String scope) { this.scope = scope; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getValue() { return value; }
    public void setValue(Integer value) { this.value = value; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
    public Boolean getVisible() { return visible; }
    public void setVisible(Boolean visible) { this.visible = visible; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
