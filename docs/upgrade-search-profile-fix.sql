-- 启明元老院 BBS：全站检索与个人档案字段兼容修复
-- 适合旧库升级；可重复执行。进入 mysql 时建议使用：mysql --default-character-set=utf8mb4 -uroot -proot
CREATE DATABASE IF NOT EXISTS qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qiming_bbs;
SET NAMES utf8mb4;

SET @db = DATABASE();

SELECT COUNT(*) INTO @exists FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db AND TABLE_NAME='bbs_users' AND COLUMN_NAME='call_sign';
SET @sql = IF(@exists=0, 'ALTER TABLE bbs_users ADD COLUMN call_sign VARCHAR(40) NULL AFTER nickname', 'SELECT "call_sign exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db AND TABLE_NAME='bbs_users' AND COLUMN_NAME='telegram_code';
SET @sql = IF(@exists=0, 'ALTER TABLE bbs_users ADD COLUMN telegram_code VARCHAR(40) NULL AFTER call_sign', 'SELECT "telegram_code exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db AND TABLE_NAME='bbs_users' AND COLUMN_NAME='council_department';
SET @sql = IF(@exists=0, 'ALTER TABLE bbs_users ADD COLUMN council_department VARCHAR(80) DEFAULT ''待分配'' AFTER bio', 'SELECT "council_department exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db AND TABLE_NAME='bbs_users' AND COLUMN_NAME='specialty';
SET @sql = IF(@exists=0, 'ALTER TABLE bbs_users ADD COLUMN specialty VARCHAR(120) NULL AFTER council_department', 'SELECT "specialty exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db AND TABLE_NAME='bbs_users' AND COLUMN_NAME='station_scope';
SET @sql = IF(@exists=0, 'ALTER TABLE bbs_users ADD COLUMN station_scope VARCHAR(20) DEFAULT ''STRATEGIC'' AFTER specialty', 'SELECT "station_scope exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db AND TABLE_NAME='bbs_users' AND COLUMN_NAME='station_name';
SET @sql = IF(@exists=0, 'ALTER TABLE bbs_users ADD COLUMN station_name VARCHAR(120) NULL AFTER station_scope', 'SELECT "station_name exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@db AND TABLE_NAME='bbs_users' AND COLUMN_NAME='station_elder_count';
SET @sql = IF(@exists=0, 'ALTER TABLE bbs_users ADD COLUMN station_elder_count INT NOT NULL DEFAULT 1 AFTER station_name', 'SELECT "station_elder_count exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE bbs_users
SET call_sign = COALESCE(NULLIF(call_sign, ''), CONCAT('LG-', UPPER(username))),
    telegram_code = COALESCE(NULLIF(telegram_code, ''), CONCAT('TG-', UPPER(username))),
    council_department = COALESCE(NULLIF(council_department, ''), '待分配'),
    station_scope = COALESCE(NULLIF(station_scope, ''), 'STRATEGIC'),
    station_name = COALESCE(NULLIF(station_name, ''), '临高首都区 / 登陆点'),
    station_elder_count = COALESCE(station_elder_count, 1);
