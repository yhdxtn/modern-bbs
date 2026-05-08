-- 评论点赞、消息通知升级脚本
-- 使用：USE qiming_bbs; SOURCE D:/github/modern-bbs/docs/upgrade-comment-likes-notifications.sql;
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS bbs_reactions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    target_type VARCHAR(20) NOT NULL,
    target_id BIGINT NOT NULL,
    reaction_type VARCHAR(20) NOT NULL DEFAULT 'LIKE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_reaction_once (user_id, target_type, target_id, reaction_type),
    KEY idx_reaction_user (user_id),
    KEY idx_reaction_target (target_type, target_id),
    CONSTRAINT fk_reaction_user FOREIGN KEY (user_id) REFERENCES bbs_users(id) ON DELETE CASCADE
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
    KEY idx_notification_target (target_type, target_id),
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES bbs_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 按已有点赞表回填评论 like_count，重复执行安全。
UPDATE bbs_replies r
LEFT JOIN (
    SELECT target_id, COUNT(*) AS cnt
    FROM bbs_reactions
    WHERE target_type = 'COMMENT' AND reaction_type = 'LIKE'
    GROUP BY target_id
) x ON x.target_id = r.id
SET r.like_count = COALESCE(x.cnt, 0);

SELECT '评论点赞与消息通知升级完成' AS result;
