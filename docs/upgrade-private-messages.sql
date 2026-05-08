USE qiming_bbs;
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS bbs_private_messages (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sender_id BIGINT NOT NULL,
    recipient_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    read_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pm_sender FOREIGN KEY (sender_id) REFERENCES bbs_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_pm_recipient FOREIGN KEY (recipient_id) REFERENCES bbs_users(id) ON DELETE CASCADE,
    KEY idx_pm_recipient_read_created (recipient_id, read_at, created_at),
    KEY idx_pm_sender_created (sender_id, created_at),
    KEY idx_pm_pair_created (sender_id, recipient_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
