-- 启明元老院 BBS：1638 年时间 + 亚洲元老态势独立模块升级脚本
-- 使用方式：mysql --default-character-set=utf8mb4 -uroot -proot
-- 进入后执行：SOURCE D:/github/modern-bbs/docs/upgrade-1638-asian-command-module.sql;

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

ALTER TABLE bbs_site_settings CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE bbs_council_locations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE bbs_site_settings MODIFY COLUMN description VARCHAR(500) NULL;
ALTER TABLE bbs_council_locations MODIFY COLUMN name VARCHAR(120) NOT NULL;

-- 新世界时间改成可直接设置历史年月日，默认约为 1638 年。
INSERT INTO bbs_site_settings (setting_key, setting_value, description) VALUES
('new_world_timezone_label', '新世界标准时 NST', '新世界时间显示名称'),
('new_world_base_datetime', '1638-05-06T08:00:00', '管理员设定的新世界当前时间，默认 1638 年左右'),
('new_world_sync_epoch_ms', CAST(ROUND(UNIX_TIMESTAMP(CURRENT_TIMESTAMP(3)) * 1000) AS CHAR), '保存新世界时间时对应的现实世界毫秒时间戳'),
('new_world_utc_offset_hours', '8', '旧版兼容字段：新世界时间相对 UTC 的小时偏移'),
('asia_1638_command_map_seeded_v1', 'true', '已初始化 1638 年亚洲元老态势模块默认数据')
ON DUPLICATE KEY UPDATE
setting_value = VALUES(setting_value),
description = VALUES(description);

-- 元老全部在亚洲：隐藏旧版欧美等非亚洲世界驻点。
UPDATE bbs_council_locations
SET elder_count = 0, visible = 0
WHERE scope = 'WORLD';

INSERT INTO bbs_council_locations (scope, name, elder_count, sort_order, visible) VALUES
('WORLD', 'China', 520, 10, 1),
('WORLD', 'Vietnam', 44, 20, 1),
('WORLD', 'Japan', 31, 30, 1),
('WORLD', 'South Korea', 28, 40, 1),
('WORLD', 'Taiwan', 58, 50, 1),
('WORLD', 'Singapore', 18, 60, 1),
('WORLD', 'Malaysia', 14, 70, 1),
('WORLD', 'Thailand', 16, 80, 1),
('WORLD', 'Philippines', 12, 90, 1),
('WORLD', 'Indonesia', 10, 100, 1),
('CHINA', '海南', 360, 5, 1),
('CHINA', '广东', 82, 10, 1),
('CHINA', '台湾', 58, 15, 1),
('CHINA', '香港', 16, 20, 1),
('CHINA', '澳门', 8, 25, 1),
('CHINA', '福建', 32, 30, 1),
('CHINA', '广西', 12, 40, 1),
('CHINA', '上海', 20, 50, 1),
('STRATEGIC', '海南主基地', 360, 10, 1),
('STRATEGIC', '广东工业转运区', 82, 20, 1),
('STRATEGIC', '台湾观察与技术联络点', 58, 30, 1),
('STRATEGIC', '济州岛远洋联络点', 28, 40, 1),
('STRATEGIC', '越南联络点', 44, 50, 1),
('STRATEGIC', '日本观察点', 31, 60, 1),
('STRATEGIC', '琼州海峡航运点', 42, 70, 1),
('STRATEGIC', '西沙前哨', 24, 80, 1),
('STRATEGIC', '南沙补给线', 18, 90, 1)
ON DUPLICATE KEY UPDATE
elder_count = VALUES(elder_count),
sort_order = VALUES(sort_order),
visible = VALUES(visible);
