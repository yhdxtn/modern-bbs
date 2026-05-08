-- 临高元老院 BBS v2 数据库结构
-- 开发环境可由 JPA ddl-auto=update 自动补表；本文件用于补充未来功能表与生产建库参考。

CREATE TABLE IF NOT EXISTS bbs_roles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL,
    description VARCHAR(255),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(32) NOT NULL UNIQUE,
    normalized_username VARCHAR(32) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    nickname VARCHAR(40) NOT NULL,
    call_sign VARCHAR(40),
    telegram_code VARCHAR(40),
    email VARCHAR(120),
    avatar_url VARCHAR(500),
    bio VARCHAR(500),
    council_department VARCHAR(80) DEFAULT '待分配',
    specialty VARCHAR(120),
    station_scope VARCHAR(20) DEFAULT 'CHINA',
    station_name VARCHAR(120),
    station_elder_count INT NOT NULL DEFAULT 1,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    post_count BIGINT NOT NULL DEFAULT 0,
    reply_count BIGINT NOT NULL DEFAULT 0,
    last_login_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_user_role_status (role, status),
    KEY idx_user_station (station_scope, station_name),
    KEY idx_user_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_site_settings (
    setting_key VARCHAR(80) PRIMARY KEY,
    setting_value VARCHAR(500) NOT NULL,
    description VARCHAR(500),
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES bbs_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES bbs_roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    parent_id BIGINT NULL,
    name VARCHAR(40) NOT NULL,
    slug VARCHAR(40) NOT NULL UNIQUE,
    description VARCHAR(500),
    sort_order INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    executive_only BIT NOT NULL DEFAULT 0,
    manager_user_id BIGINT NULL,
    thread_count BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_category_parent FOREIGN KEY (parent_id) REFERENCES bbs_categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_category_manager FOREIGN KEY (manager_user_id) REFERENCES bbs_users(id) ON DELETE SET NULL,
    KEY idx_category_parent_sort (parent_id, sort_order),
    KEY idx_category_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS bbs_department_banners (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_id BIGINT NOT NULL,
    title VARCHAR(80) NOT NULL,
    subtitle VARCHAR(220),
    image_url VARCHAR(500) NOT NULL,
    link_text VARCHAR(40),
    link_url VARCHAR(500),
    sort_order INT NOT NULL DEFAULT 0,
    visible BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_department_banner_category FOREIGN KEY (category_id) REFERENCES bbs_categories(id) ON DELETE CASCADE,
    UNIQUE KEY uk_department_banner_category_title (category_id, title),
    KEY idx_department_banner_category_sort (category_id, visible, sort_order),
    KEY idx_department_banner_visible (visible)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_threads (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(160) NOT NULL,
    author_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    view_count BIGINT NOT NULL DEFAULT 0,
    comment_count BIGINT NOT NULL DEFAULT 0,
    like_count BIGINT NOT NULL DEFAULT 0,
    pinned BIT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
    last_replied_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_thread_author FOREIGN KEY (author_id) REFERENCES bbs_users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_thread_category FOREIGN KEY (category_id) REFERENCES bbs_categories(id) ON DELETE RESTRICT,
    KEY idx_thread_category_updated (category_id, pinned, updated_at),
    KEY idx_thread_author (author_id, created_at),
    KEY idx_thread_created_at (created_at),
    KEY idx_thread_updated_at (updated_at),
    KEY idx_thread_status (status),
    KEY idx_thread_title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_thread_contents (
    thread_id BIGINT PRIMARY KEY,
    content LONGTEXT NOT NULL,
    CONSTRAINT fk_thread_content_thread FOREIGN KEY (thread_id) REFERENCES bbs_threads(id) ON DELETE CASCADE,
    FULLTEXT KEY ft_thread_content (content)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_replies (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    thread_id BIGINT NOT NULL,
    author_id BIGINT NOT NULL,
    parent_id BIGINT NULL,
    floor_no INT NOT NULL DEFAULT 0,
    content LONGTEXT NOT NULL,
    like_count BIGINT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_reply_thread FOREIGN KEY (thread_id) REFERENCES bbs_threads(id) ON DELETE CASCADE,
    CONSTRAINT fk_reply_author FOREIGN KEY (author_id) REFERENCES bbs_users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_reply_parent FOREIGN KEY (parent_id) REFERENCES bbs_replies(id) ON DELETE SET NULL,
    KEY idx_reply_thread_created (thread_id, created_at),
    KEY idx_reply_author (author_id, created_at),
    KEY idx_reply_status (status),
    KEY idx_reply_created_at (created_at),
    FULLTEXT KEY ft_reply_content (content)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_tags (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    slug VARCHAR(40) NOT NULL UNIQUE,
    use_count BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_thread_tags (
    thread_id BIGINT NOT NULL,
    tag_id BIGINT NOT NULL,
    PRIMARY KEY (thread_id, tag_id),
    CONSTRAINT fk_thread_tags_thread FOREIGN KEY (thread_id) REFERENCES bbs_threads(id) ON DELETE CASCADE,
    CONSTRAINT fk_thread_tags_tag FOREIGN KEY (tag_id) REFERENCES bbs_tags(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_reactions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    target_type VARCHAR(20) NOT NULL,
    target_id BIGINT NOT NULL,
    reaction_type VARCHAR(20) NOT NULL DEFAULT 'LIKE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_reaction_once (user_id, target_type, target_id, reaction_type),
    KEY idx_reaction_target (target_type, target_id),
    CONSTRAINT fk_reaction_user FOREIGN KEY (user_id) REFERENCES bbs_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_bookmarks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    thread_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_bookmark_once (user_id, thread_id),
    KEY idx_bookmark_user_created (user_id, created_at),
    CONSTRAINT fk_bookmark_user FOREIGN KEY (user_id) REFERENCES bbs_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_bookmark_thread FOREIGN KEY (thread_id) REFERENCES bbs_threads(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_council_locations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    scope VARCHAR(20) NOT NULL,
    name VARCHAR(120) NOT NULL,
    elder_count INT NOT NULL DEFAULT 0,
    sort_order INT NOT NULL DEFAULT 0,
    visible BIT NOT NULL DEFAULT 1,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_council_location_scope_name (scope, name),
    KEY idx_council_location_scope_sort (scope, sort_order),
    KEY idx_council_location_visible (visible)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    type VARCHAR(40) NOT NULL,
    title VARCHAR(160) NOT NULL,
    content VARCHAR(500),
    target_type VARCHAR(20),
    target_id BIGINT,
    read_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_notification_user_read_created (user_id, read_at, created_at),
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES bbs_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_attachments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    uploader_id BIGINT NOT NULL,
    target_type VARCHAR(20),
    target_id BIGINT,
    original_name VARCHAR(255) NOT NULL,
    storage_path VARCHAR(500) NOT NULL,
    content_type VARCHAR(120),
    size_bytes BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_attachment_target (target_type, target_id),
    CONSTRAINT fk_attachment_user FOREIGN KEY (uploader_id) REFERENCES bbs_users(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_audit_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    actor_id BIGINT NULL,
    action VARCHAR(80) NOT NULL,
    target_type VARCHAR(40),
    target_id BIGINT,
    ip_address VARCHAR(64),
    user_agent VARCHAR(500),
    detail JSON NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_audit_actor_created (actor_id, created_at),
    KEY idx_audit_target (target_type, target_id),
    CONSTRAINT fk_audit_actor FOREIGN KEY (actor_id) REFERENCES bbs_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_login_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NULL,
    username VARCHAR(64),
    success BIT NOT NULL,
    ip_address VARCHAR(64),
    user_agent VARCHAR(500),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_login_user_created (user_id, created_at),
    KEY idx_login_username_created (username, created_at),
    CONSTRAINT fk_login_user FOREIGN KEY (user_id) REFERENCES bbs_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
