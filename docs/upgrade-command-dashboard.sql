-- 启明元老院 BBS：新增“新世界时间 + 元老分布 + 个人驻点”数据库结构（SQL 修复版）
-- 兼容 Windows MySQL 命令行，先指定数据库与 UTF-8 编码。

CREATE DATABASE IF NOT EXISTS qiming_bbs
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE qiming_bbs;
SET NAMES utf8mb4;

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
ALTER TABLE bbs_council_locations MODIFY COLUMN name VARCHAR(120) NOT NULL;
ALTER TABLE bbs_site_settings MODIFY COLUMN description VARCHAR(500) NULL;

-- 下面三句用于旧库补字段；如果提示 Duplicate column name，说明已经存在，跳过即可。
ALTER TABLE bbs_users ADD COLUMN station_scope VARCHAR(20) DEFAULT 'CHINA';
ALTER TABLE bbs_users ADD COLUMN station_name VARCHAR(120) NULL;
ALTER TABLE bbs_users ADD COLUMN station_elder_count INT NOT NULL DEFAULT 1;

-- 导入海南、广东、台湾、济州岛等重点驻点：
-- SOURCE D:/github/modern-bbs/docs/upgrade-hainan-strategic-map.sql;
