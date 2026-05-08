-- 临高元老院：临高首都区 / 登陆点与全员发帖讨论升级脚本
-- Windows 命令行执行前建议：mysql --default-character-set=utf8mb4 -uroot -proot

CREATE DATABASE IF NOT EXISTS qiming_bbs
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE qiming_bbs;
SET NAMES utf8mb4;

-- 扩大字段，避免“临高首都区 / 登陆点”等名称过长。
ALTER TABLE bbs_council_locations MODIFY COLUMN name VARCHAR(120) NOT NULL;
ALTER TABLE bbs_users MODIFY COLUMN station_name VARCHAR(120) NULL;
ALTER TABLE bbs_site_settings MODIFY COLUMN description VARCHAR(500) NULL;

-- 注册用户权限说明：普通 USER 即可发帖、回复、参与讨论。
INSERT INTO bbs_roles (id, code, name, description) VALUES
(1, 'USER', '普通元老', '登记入岛的普通元老账号，可发帖、回复和参与讨论'),
(2, 'ADMIN', '执委会管理员', '拥有后台管理权限'),
(3, 'MODERATOR', '分区执事', '可管理指定分区内容')
ON DUPLICATE KEY UPDATE
name = VALUES(name),
description = VALUES(description);

-- 旧用户如果还没有驻点，默认归入临高首都区 / 登陆点。
UPDATE bbs_users
SET station_scope = 'STRATEGIC',
    station_name = '临高首都区 / 登陆点',
    station_elder_count = CASE WHEN station_elder_count IS NULL OR station_elder_count < 1 THEN 1 ELSE station_elder_count END
WHERE station_name IS NULL OR station_name = '';


-- 新增临高首都区建设分区，方便围绕登陆点与首都区规划发帖讨论。
INSERT INTO bbs_categories (id, parent_id, name, slug, description, sort_order, status) VALUES
(9, NULL, '临高首都区建设', 'lingao-capital', '临高登陆点、百仞城、博铺港、首都区规划与城市治理', 15, 'ACTIVE')
ON DUPLICATE KEY UPDATE
name = VALUES(name),
description = VALUES(description),
sort_order = VALUES(sort_order),
status = VALUES(status);

-- 亚洲范围：所有元老均在亚洲，重点有越南、日本、济州岛等。
INSERT INTO bbs_council_locations (scope, name, elder_count, sort_order, visible) VALUES
('WORLD', 'China', 620, 10, 1),
('WORLD', 'Vietnam', 44, 20, 1),
('WORLD', 'Japan', 31, 30, 1),
('WORLD', 'South Korea', 28, 40, 1),
('WORLD', 'Taiwan', 58, 50, 1),
('WORLD', 'Singapore', 18, 60, 1),
('WORLD', 'Malaysia', 14, 70, 1),
('WORLD', 'Thailand', 16, 80, 1),
('WORLD', 'Philippines', 12, 90, 1),
('WORLD', 'Indonesia', 10, 100, 1)
ON DUPLICATE KEY UPDATE
elder_count = VALUES(elder_count),
sort_order = VALUES(sort_order),
visible = VALUES(visible);

-- 中国省份层：临高属于海南，所以省份图仍以“海南”为主。
INSERT INTO bbs_council_locations (scope, name, elder_count, sort_order, visible) VALUES
('CHINA', '海南', 470, 5, 1),
('CHINA', '广东', 82, 10, 1),
('CHINA', '台湾', 58, 15, 1),
('CHINA', '香港', 16, 20, 1),
('CHINA', '澳门', 8, 25, 1),
('CHINA', '福建', 32, 30, 1),
('CHINA', '广西', 12, 40, 1),
('CHINA', '上海', 20, 50, 1)
ON DUPLICATE KEY UPDATE
elder_count = VALUES(elder_count),
sort_order = VALUES(sort_order),
visible = VALUES(visible);

-- 核心图：临高作为穿越者登陆点、事实首都区和最高议事中心单独显示。
INSERT INTO bbs_council_locations (scope, name, elder_count, sort_order, visible) VALUES
('STRATEGIC', '临高首都区 / 登陆点', 420, 5, 1),
('STRATEGIC', '百仞城政务区', 160, 8, 1),
('STRATEGIC', '博铺港', 96, 9, 1),
('STRATEGIC', '海南主基地', 470, 10, 1),
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

INSERT INTO bbs_site_settings (setting_key, setting_value, description) VALUES
('lingao_1638_capital_map_seeded_v1', 'true', '已初始化临高首都区与亚洲元老态势模块默认数据')
ON DUPLICATE KEY UPDATE description = VALUES(description);
