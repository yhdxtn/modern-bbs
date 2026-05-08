CREATE DATABASE IF NOT EXISTS qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qiming_bbs;
SET NAMES utf8mb4;

SET @db_name = DATABASE();

SET @sql = (
  SELECT IF(
    EXISTS(
      SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'bbs_users' AND COLUMN_NAME = 'call_sign'
    ),
    'SELECT ''bbs_users.call_sign already exists'' AS message',
    'ALTER TABLE bbs_users ADD COLUMN call_sign VARCHAR(40) NULL AFTER nickname'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS(
      SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'bbs_users' AND COLUMN_NAME = 'telegram_code'
    ),
    'SELECT ''bbs_users.telegram_code already exists'' AS message',
    'ALTER TABLE bbs_users ADD COLUMN telegram_code VARCHAR(40) NULL AFTER call_sign'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE bbs_users
SET call_sign = CONCAT('LG-', UPPER(username))
WHERE call_sign IS NULL OR call_sign = '';

UPDATE bbs_users
SET telegram_code = CONCAT('TG-', UPPER(username))
WHERE telegram_code IS NULL OR telegram_code = '';

-- 保持临高首都区/公告分区说明更符合现在的首页显示逻辑。
UPDATE bbs_categories
SET description = '临高登陆点、百仞城、博铺港、首都区规划、内网通信与城市治理'
WHERE slug = 'lingao-capital';

UPDATE bbs_categories
SET description = '正式规则、公共通知、重要决议和执委会公告，仅执委会代表可发布',
    executive_only = b'1'
WHERE slug = 'senate';
