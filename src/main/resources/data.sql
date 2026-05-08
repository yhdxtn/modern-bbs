INSERT INTO bbs_roles (id, code, name, description) VALUES
(1, 'USER', '普通元老', '登记入岛的普通元老账号，可发帖、回复和参与讨论'),
(2, 'ADMIN', '执委会管理员', '拥有后台管理权限'),
(3, 'EXECUTIVE', '执委会代表', '可以在元老院公告、执委会公报等正式分区发帖'),
(4, 'MODERATOR', '分区执事', '可管理指定分区内容')
ON DUPLICATE KEY UPDATE
code = VALUES(code),
name = VALUES(name),
description = VALUES(description);

INSERT INTO bbs_categories (id, parent_id, name, slug, description, sort_order, status, executive_only) VALUES
(1, NULL, '元老院公告', 'senate', '正式规则、公共通知、重要决议和执委会公告，仅执委会代表可发布', 10, 'ACTIVE', 1),
(9, NULL, '临高首都区建设', 'lingao-capital', '临高登陆点、百仞城、博铺港、首都区规划与城市治理', 15, 'ACTIVE', 0),
(2, NULL, '工业建设', 'industry', '机械、冶金、化工、电力、制造与基础设施方案', 20, 'ACTIVE', 0),
(3, NULL, '农业与物资', 'agriculture', '粮食、种植、畜牧、仓储、后勤和物资调配', 30, 'ACTIVE', 0),
(4, NULL, '医疗卫生', 'medicine', '疾病防治、药品、公共卫生、急救和检疫事务', 40, 'ACTIVE', 0),
(5, NULL, '军务安保', 'security', '营地防卫、武器训练、治安巡逻和风险预案', 50, 'ACTIVE', 0),
(6, NULL, '航海贸易', 'navigation', '港口、船只、航线、贸易和外部接触记录', 60, 'ACTIVE', 0),
(7, NULL, '教育档案', 'education', '识字、技术培训、教材编写和人才培养', 70, 'ACTIVE', 0),
(8, NULL, '政务制度', 'governance', '行政组织、法律制度、财政税务和社会治理', 80, 'ACTIVE', 0)
ON DUPLICATE KEY UPDATE
parent_id = VALUES(parent_id),
name = VALUES(name),
slug = VALUES(slug),
description = VALUES(description),
sort_order = VALUES(sort_order),
status = VALUES(status),
executive_only = VALUES(executive_only);

INSERT INTO bbs_site_settings (setting_key, setting_value, description) VALUES
('new_world_timezone_label', '新世界标准时 NST', '新世界时间显示名称'),
('new_world_base_datetime', '1638-05-06T08:00:00', '管理员设定的新世界当前时间，默认 1638 年左右'),
('new_world_sync_epoch_ms', '0', '保存新世界时间时对应的现实世界毫秒时间戳'),
('new_world_utc_offset_hours', '8', '旧版兼容字段：新世界时间相对 UTC 的小时偏移')
ON DUPLICATE KEY UPDATE
setting_value = bbs_site_settings.setting_value,
description = VALUES(description);

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
('WORLD', 'Indonesia', 10, 100, 1),
('CHINA', '海南', 470, 5, 1),
('CHINA', '广东', 82, 10, 1),
('CHINA', '台湾', 58, 15, 1),
('CHINA', '香港', 16, 20, 1),
('CHINA', '澳门', 8, 25, 1),
('CHINA', '福建', 32, 30, 1),
('CHINA', '广西', 12, 40, 1),
('CHINA', '上海', 20, 50, 1),
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
elder_count = bbs_council_locations.elder_count,
sort_order = bbs_council_locations.sort_order,
visible = bbs_council_locations.visible;


INSERT INTO bbs_department_banners (category_id, title, subtitle, image_url, link_text, link_url, sort_order, visible) VALUES
(9, '临高首都区一期扩建', '围绕登陆点、百仞城与博铺港建立首都区秩序，优先推进居住、防疫、仓储和港口调度。', 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=9', 10, 1),
(2, '工业委员会设备攻关', '蒸汽动力、机械维修、盐硝化工与基础电力项目集中归档，方便各组协同推进。', 'https://images.unsplash.com/photo-1513828583688-c52646db42da?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=2', 10, 1),
(3, '农业与物资周转计划', '粮食、甘蔗、仓储、防霉与后勤配送按临高首都区需求统筹调配。', 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=3', 10, 1),
(5, '港口防御与巡逻制度', '军务安保分区集中讨论营地防御、港口警戒、治安巡逻和电报预警。', 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=5', 10, 1)
ON DUPLICATE KEY UPDATE title = bbs_department_banners.title;
