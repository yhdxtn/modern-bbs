CREATE DATABASE IF NOT EXISTS qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qiming_bbs;
SET NAMES utf8mb4;

ALTER TABLE bbs_council_locations MODIFY COLUMN name VARCHAR(120) NOT NULL;
ALTER TABLE bbs_council_locations MODIFY COLUMN description VARCHAR(500);

-- MySQL 8.0 不支持 ADD COLUMN IF NOT EXISTS，改为兼容写法。
SET @db_name = DATABASE();

SET @sql = (
  SELECT IF(
    EXISTS(
      SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'bbs_users' AND COLUMN_NAME = 'council_department'
    ),
    'SELECT ''bbs_users.council_department already exists'' AS message',
    'ALTER TABLE bbs_users ADD COLUMN council_department VARCHAR(80) DEFAULT ''待分配'' AFTER bio'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS(
      SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'bbs_users' AND COLUMN_NAME = 'specialty'
    ),
    'SELECT ''bbs_users.specialty already exists'' AS message',
    'ALTER TABLE bbs_users ADD COLUMN specialty VARCHAR(120) NULL AFTER council_department'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE bbs_council_locations SET description='临高为穿越者登陆地、事实首都区和最高议事中心，可使用单片机手机内网。' WHERE name='临高首都区';
UPDATE bbs_council_locations SET description='百仞城为元老院政务、档案与行政协调核心，可使用单片机手机内网。' WHERE name='百仞城政务区';
UPDATE bbs_council_locations SET description='博铺港承担海运、补给与工商业转运任务，可使用单片机手机内网。' WHERE name='博铺港';
