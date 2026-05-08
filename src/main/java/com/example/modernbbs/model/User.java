package com.example.modernbbs.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Locale;

@Entity
@Table(name = "bbs_users", indexes = {
        @Index(name = "idx_user_username", columnList = "username", unique = true),
        @Index(name = "idx_user_normalized_username", columnList = "normalized_username", unique = true),
        @Index(name = "idx_user_role_status", columnList = "role, status"),
        @Index(name = "idx_user_station", columnList = "station_scope, station_name"),
        @Index(name = "idx_user_created_at", columnList = "created_at")
})
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 32)
    private String username;

    @Column(name = "normalized_username", nullable = false, unique = true, length = 32)
    private String normalizedUsername;

    @Column(name = "password_hash", nullable = false, length = 100)
    private String passwordHash;

    @Column(nullable = false, length = 40)
    private String nickname;

    /** 论坛公开档案名称：临高内驻元老优先显示呼号；外驻元老优先显示电报号。 */
    @Column(name = "call_sign", length = 40)
    private String callSign;

    /** 外驻元老使用的电报编号，例如 TG-GD-001、TG-JP-008。 */
    @Column(name = "telegram_code", length = 40)
    private String telegramCode;

    @Column(length = 120)
    private String email;

    @Column(name = "avatar_url", length = 500)
    private String avatarUrl;

    @Column(length = 500)
    private String bio;

    /** 所属委员会、工作组或临时部门，例如 工业委员会、农业组、医务组、航海组。 */
    @Column(name = "council_department", length = 80, columnDefinition = "VARCHAR(80) DEFAULT '待分配'")
    private String councilDepartment = "待分配";

    /** 个人专长或小说化职能，例如 机械维修、无线电、电报、医务、制图、行政。 */
    @Column(length = 120)
    private String specialty;

    /** 驻点范围：WORLD、CHINA 或 STRATEGIC，用于个人档案与元老分布统计。 */
    @Column(name = "station_scope", length = 20, columnDefinition = "VARCHAR(20) DEFAULT 'CHINA'")
    private String stationScope = "CHINA";

    /** 驻点名称：例如 临高首都区 / 登陆点、海南、广东、台湾、济州岛、China、Vietnam，需与地图名称一致。 */
    @Column(name = "station_name", length = 120)
    private String stationName;

    /** 个人档案中登记的同行元老数量，便于后续做自动汇总或审核。 */
    @Column(name = "station_elder_count", nullable = false, columnDefinition = "INT DEFAULT 1")
    private Integer stationElderCount = 1;

    /**
     * 保留简单角色字段，方便当前代码直接判断后台权限。
     * 数据库里同时预留了 bbs_roles / bbs_user_roles，后续可平滑升级为 RBAC 权限模型。
     */
    @Column(nullable = false, length = 20)
    private String role = "USER";

    @Column(nullable = false, length = 20)
    private String status = "ACTIVE";

    @Column(name = "post_count", nullable = false)
    private Long postCount = 0L;

    @Column(name = "reply_count", nullable = false)
    private Long replyCount = 0L;

    @Column(name = "last_login_at")
    private LocalDateTime lastLoginAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (createdAt == null) createdAt = now;
        if (updatedAt == null) updatedAt = now;
        normalizeUsername();
        if (nickname == null || nickname.isBlank()) {
            nickname = username;
        }
        if (callSign == null || callSign.isBlank()) {
            callSign = generateNumericCallSign(username);
        }
        if (telegramCode == null || telegramCode.isBlank()) {
            telegramCode = "T" + generateNumericCallSign(username);
        }
        // 不再给无头像用户自动写入远程默认头像。前端会用昵称首字生成圆形占位头像，避免评论区显示呼号或外链头像。
        if (avatarUrl != null && avatarUrl.isBlank()) {
            avatarUrl = null;
        }
        if (role == null || role.isBlank()) role = "USER";
        if (status == null || status.isBlank()) status = "ACTIVE";
        if (councilDepartment == null || councilDepartment.isBlank()) councilDepartment = "待分配";
        if (postCount == null) postCount = 0L;
        if (replyCount == null) replyCount = 0L;
        if (stationScope == null || stationScope.isBlank()) stationScope = "CHINA";
        if (stationElderCount == null || stationElderCount < 0) stationElderCount = 1;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
        normalizeUsername();
    }

    private void normalizeUsername() {
        if (username != null) {
            normalizedUsername = username.trim().toLowerCase(Locale.ROOT);
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) {
        this.username = username;
        normalizeUsername();
    }
    public String getNormalizedUsername() { return normalizedUsername; }
    public void setNormalizedUsername(String normalizedUsername) { this.normalizedUsername = normalizedUsername; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getDisplayName() {
        if (nickname != null && !nickname.isBlank()) return nickname;
        return username == null ? "元老" : username;
    }

    public String getAvatarInitial() {
        String name = getDisplayName();
        if (name == null || name.isBlank()) return "元";
        int firstCodePoint = name.codePointAt(0);
        return new String(Character.toChars(firstCodePoint)).toUpperCase(Locale.ROOT);
    }

    public boolean isCustomAvatar() {
        if (avatarUrl == null || avatarUrl.isBlank()) return false;
        String lower = avatarUrl.toLowerCase(Locale.ROOT);
        return !lower.contains("api.dicebear.com") && !lower.contains("initials/svg");
    }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public String getCouncilDepartment() { return councilDepartment == null || councilDepartment.isBlank() ? "待分配" : councilDepartment; }
    public void setCouncilDepartment(String councilDepartment) { this.councilDepartment = councilDepartment; }
    public String getSpecialty() { return specialty == null ? "" : specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }
    public String getCallSign() { return callSign == null ? "" : callSign; }
    public void setCallSign(String callSign) { this.callSign = callSign; }
    public String getTelegramCode() { return telegramCode == null ? "" : telegramCode; }
    public void setTelegramCode(String telegramCode) { this.telegramCode = telegramCode; }

    public String getArchiveDisplayCode() {
        String primary = getCallSign();
        if (primary != null && !primary.isBlank()) return primary;
        return generateNumericCallSign(username);
    }

    public String getArchiveDisplayLabel() {
        return "呼号";
    }

    private String generateNumericCallSign(String seed) {
        String value = seed == null || seed.isBlank() ? "yuanlao" : seed.trim().toLowerCase(Locale.ROOT);
        int hash = Math.abs(value.hashCode());
        return String.format(Locale.ROOT, "%06d", hash % 1000000);
    }

    /**
     * 临高是登陆点与事实首都区。部署类型只用于档案归类，不再在公开列表里显示通信方式。
     */
    public boolean isLingaoResident() {
        String name = stationName == null ? "" : stationName;
        return name.contains("临高") || name.contains("百仞城") || name.contains("博铺港");
    }

    public String getDeploymentType() {
        return isLingaoResident() ? "临高内驻元老" : "外驻元老";
    }

    public String getCommunicationMode() {
        return "内部联络";
    }



    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(role);
    }

    public boolean isExecutiveRepresentative() {
        return "ADMIN".equalsIgnoreCase(role) || "EXECUTIVE".equalsIgnoreCase(role);
    }

    public String getRoleLabel() {
        if ("ADMIN".equalsIgnoreCase(role)) return "管理员";
        if ("EXECUTIVE".equalsIgnoreCase(role)) return "执委会代表";
        return "普通元老";
    }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getStationScope() { return stationScope; }
    public void setStationScope(String stationScope) { this.stationScope = stationScope; }
    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }
    public Integer getStationElderCount() { return stationElderCount; }
    public void setStationElderCount(Integer stationElderCount) { this.stationElderCount = stationElderCount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Long getPostCount() { return postCount; }
    public void setPostCount(Long postCount) { this.postCount = postCount; }
    public Long getReplyCount() { return replyCount; }
    public void setReplyCount(Long replyCount) { this.replyCount = replyCount; }
    public LocalDateTime getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(LocalDateTime lastLoginAt) { this.lastLoginAt = lastLoginAt; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
