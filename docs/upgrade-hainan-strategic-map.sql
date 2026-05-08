-- 启明元老院 BBS：海南—南海核心态势图升级脚本（SQL 修复版）
-- 解决：No database selected / name 字段太短 / Windows MySQL 中文乱码

CREATE DATABASE IF NOT EXISTS qiming_bbs
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE qiming_bbs;
SET NAMES utf8mb4;
SET character_set_client = utf8mb4;
SET character_set_connection = utf8mb4;
SET character_set_results = utf8mb4;

ALTER DATABASE qiming_bbs
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bbs_site_settings (
    setting_key VARCHAR(80) PRIMARY KEY,
    setting_value VARCHAR(500) NOT NULL,
    description VARCHAR(500),
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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

-- 修复旧表：把相关表统一改为 utf8mb4，并扩大字段长度。
ALTER TABLE bbs_site_settings CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE bbs_council_locations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE bbs_council_locations MODIFY COLUMN scope VARCHAR(20) NOT NULL;
ALTER TABLE bbs_council_locations MODIFY COLUMN name VARCHAR(120) NOT NULL;
ALTER TABLE bbs_site_settings MODIFY COLUMN description VARCHAR(500) NULL;

-- 如果 bbs_users 已经存在，则修复个人驻点字段。若提示 Duplicate column name，可忽略。
-- 注意：下面三句在字段不存在时才需要；已存在时不用重复执行。

INSERT INTO bbs_council_locations (scope, name, elder_count, sort_order, visible) VALUES
('WORLD', 'China', 520, 10, 1),
('WORLD', 'South Korea', 36, 90, 1),
('WORLD', 'Singapore', 18, 100, 1),
('WORLD', 'Japan', 22, 110, 1),
('CHINA', '海南', 260, 5, 1),
('CHINA', '广东', 82, 10, 1),
('CHINA', '台湾', 58, 15, 1),
('CHINA', '香港', 16, 20, 1),
('CHINA', '澳门', 8, 25, 1),
('CHINA', '福建', 32, 30, 1),
('STRATEGIC', '海南主基地', 260, 10, 1),
('STRATEGIC', '广东工业转运区', 82, 20, 1),
('STRATEGIC', '台湾观察与技术联络点', 58, 30, 1),
('STRATEGIC', '济州岛远洋联络点', 36, 40, 1),
('STRATEGIC', '琼州海峡航运点', 42, 50, 1),
('STRATEGIC', '西沙前哨', 24, 60, 1),
('STRATEGIC', '南沙补给线', 18, 70, 1)
ON DUPLICATE KEY UPDATE
elder_count = VALUES(elder_count),
sort_order = VALUES(sort_order),
visible = VALUES(visible);

INSERT INTO bbs_site_settings (setting_key, setting_value, description) VALUES
('hainan_strategic_map_seeded_v2', 'true', '已初始化海南核心态势地图默认数据'),
('new_world_time_label', '新世界标准时 NST', '首页时间卡片名称'),
('new_world_utc_offset', '8', '新世界时间相对 UTC 的小时偏移')
ON DUPLICATE KEY UPDATE
setting_value = VALUES(setting_value),
description = VALUES(description);
