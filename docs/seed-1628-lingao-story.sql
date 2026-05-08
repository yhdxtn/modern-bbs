-- 启明元老院 BBS：1628 年 D日—D+95日 剧情种子数据
-- 说明：本脚本会插入一批原创拟制用户、帖子和评论，发布时间全部设为 1628 年。
-- 使用方式：mysql --default-character-set=utf8mb4 -uroot -proot
-- 进入后执行：SOURCE D:/github/modern-bbs/docs/seed-1628-lingao-story.sql;

CREATE DATABASE IF NOT EXISTS qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qiming_bbs;
SET NAMES utf8mb4;
SET character_set_client = utf8mb4;
SET character_set_connection = utf8mb4;
SET character_set_results = utf8mb4;

ALTER DATABASE qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 让首页新世界时间回到 1628 年剧情线。
INSERT INTO bbs_site_settings (setting_key, setting_value, description) VALUES
('new_world_timezone_label', '新世界标准时 NST', '新世界时间显示名称'),
('new_world_base_datetime', '1628-12-20T18:00:00', '1628 年剧情线默认时间：第一批高产脱毒红薯下种后'),
('new_world_sync_epoch_ms', CAST(ROUND(UNIX_TIMESTAMP(CURRENT_TIMESTAMP(3)) * 1000) AS CHAR), '保存新世界时间时对应的现实世界毫秒时间戳'),
('new_world_utc_offset_hours', '8', '旧版兼容字段')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value), description = VALUES(description);

-- 基础角色
INSERT INTO bbs_roles (id, code, name, description) VALUES
(1, 'USER', '普通元老', '登记入岛的普通元老账号，可发帖、回复和参与讨论'),
(2, 'ADMIN', '执委会管理员', '拥有后台管理权限'),
(3, 'EXECUTIVE', '执委会代表', '可以在元老院公告、执委会公报等正式分区发帖'),
(4, 'MODERATOR', '分区执事', '可管理指定分区内容')
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description);

-- 分区
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('元老院公告', 'senate', '正式规则、公共通知、重要决议和执委会公告，仅执委会代表可发布', 10, 'ACTIVE', 1, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('临高首都区建设', 'lingao-capital', '临高登陆点、百仞城、博铺港、首都区规划与城市治理', 15, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('工业建设', 'industry', '机械、冶金、化工、电力、制造与基础设施方案', 20, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('农业与物资', 'agriculture', '粮食、种植、畜牧、仓储、后勤和物资调配', 30, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('医疗卫生', 'medicine', '疾病防治、药品、公共卫生、急救和检疫事务', 40, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('军务安保', 'security', '营地防卫、武器训练、治安巡逻和风险预案', 50, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('航海贸易', 'navigation', '港口、船只、航线、贸易和外部接触记录', 60, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('教育档案', 'education', '识字、技术培训、教材编写和人才培养', 70, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('政务制度', 'governance', '行政组织、法律制度、财政税务和社会治理', 80, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('通信电力', 'communications', '临高内网、电台、步话机、外驻电报和电力调度', 90, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('广州外务站', 'guangzhou-station', '广州先遣、商贸接触、外部情报和纪律通报', 100, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, created_at, updated_at) VALUES ('黎区工作', 'li-area', '黎区探险、联络、道路、医疗与群众工作记录', 110, 'ACTIVE', 0, '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);

-- 1628 剧情用户：默认登录密码均为 123456；邮箱不公开。
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('beiwei', 'beiwei', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '北炜', 'LG-BEWEI', 'TG-BW-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属军务安保，主要负责前导侦察、港口警戒。', '军务安保', '前导侦察、港口警戒', 'STRATEGIC', '博铺港', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('yanquezhi', 'yanquezhi', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '燕雀志', 'LG-YANQUEZHI', 'TG-YQZ-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属工程建设组，主要负责浮动码头、临时结构。', '工程建设组', '浮动码头、临时结构', 'STRATEGIC', '博铺港', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('meiwan', 'meiwan', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '梅晚', 'LG-MEIWAN', 'TG-MW-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属工程建设组，主要负责道路、港务、营地施工。', '工程建设组', '道路、港务、营地施工', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('rannyao', 'rannyao', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '冉耀', 'LG-RANYAO', 'TG-RY-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属治安组，主要负责营地治安、审讯登记。', '治安组', '营地治安、审讯登记', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('guoyi', 'guoyi', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '郭逸', 'LG-GUOYI', 'TG-GY-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属执法观察组，主要负责执法流程、证据记录。', '执法观察组', '执法流程、证据记录', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('xuezirang', 'xuezirang', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '薛子良', 'LG-XUEZIRANG', 'TG-XZL-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属执法观察组，主要负责现场处置、纠纷调停。', '执法观察组', '现场处置、纠纷调停', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('salina', 'salina', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '萨琳娜', 'LG-SALINA', 'TG-SLN-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属外务联络组，主要负责语言、接触纪律、外务记录。', '外务联络组', '语言、接触纪律、外务记录', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('wude', 'wude', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '邬德', 'LG-WUDE', 'TG-WD-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属政务制度组，主要负责归化民管理、用工制度。', '政务制度组', '归化民管理、用工制度', 'STRATEGIC', '百仞城政务区', 1, 'EXECUTIVE', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('zhuotianmin', 'zhuotianmin', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '卓天敏', 'LG-ZHUOTIANMIN', 'TG-ZTM-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属工程监理组，主要负责施工监理、质量验收。', '工程监理组', '施工监理、质量验收', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('xiaozishan', 'xiaozishan', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '萧子山', 'LG-XIAOZISHAN', 'TG-XZS-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属航海贸易组，主要负责海运、广州先遣、贸易纪律。', '航海贸易组', '海运、广州先遣、贸易纪律', 'WORLD', 'China', 1, 'EXECUTIVE', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('wendesi', 'wendesi', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '文德嗣', 'LG-WENDESI', 'TG-WDS-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属黎区工作组，主要负责黎区探险、基层联络。', '黎区工作组', '黎区探险、基层联络', 'CHINA', '海南', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('wangluobing', 'wangluobing', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '王洛宾', 'LG-WANGLUOBING', 'TG-WLB-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属机械兵工组，主要负责机械加工、线膛枪、米尼弹。', '机械兵工组', '机械加工、线膛枪、米尼弹', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('xiyazhou', 'xiyazhou', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '席亚洲', 'LG-XIYAZHOU', 'TG-XYZ-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属基层建设组，主要负责发动群众、农庄组织。', '基层建设组', '发动群众、农庄组织', 'CHINA', '海南', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('duwen', 'duwen', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '杜雯', 'LG-DUWEN', 'TG-DW-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属基层建设组，主要负责讲习所、识字教育、妇女工作。', '基层建设组', '讲习所、识字教育、妇女工作', 'CHINA', '海南', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('jituisi', 'jituisi', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '季退思', 'LG-JITUISI', 'TG-JTS-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属化工组，主要负责炸药、雷汞、玻璃原料。', '化工组', '炸药、雷汞、玻璃原料', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('maqianzhu', 'maqianzhu', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '马千瞩', 'LG-MAQIANZHU', 'TG-MQZ-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属计划委员会，主要负责制度设计、劳工改革、计划文件。', '计划委员会', '制度设计、劳工改革、计划文件', 'STRATEGIC', '百仞城政务区', 1, 'EXECUTIVE', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('duguqiuhun', 'duguqiuhun', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '独孤求婚', 'LG-DUGUQI', 'TG-DGQH-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属东门市派出所，主要负责治安巡逻、打非行动。', '东门市派出所', '治安巡逻、打非行动', 'CHINA', '海南', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('jiwusheng', 'jiwusheng', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '季无声', 'LG-JIWUSHENG', 'TG-JWS-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属冶金组，主要负责炼钢、炉料、热处理。', '冶金组', '炼钢、炉料、热处理', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('zhanwuya', 'zhanwuya', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '展无涯', 'LG-ZHANWUYA', 'TG-ZWY-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属兵工组，主要负责铸炮、弹丸、工装夹具。', '兵工组', '铸炮、弹丸、工装夹具', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('linshenhe', 'linshenhe', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '林深河', 'LG-LINSHENHE', 'TG-LSH-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属兵工组，主要负责枪管加工、弹药测试。', '兵工组', '枪管加工、弹药测试', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('liupan', 'liupan', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '刘盼', 'LG-LIUPAN', 'TG-LP-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属医务组，主要负责公共卫生、检疫、营地消杀。', '医务组', '公共卫生、检疫、营地消杀', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('chentao', 'chentao', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '陈韬', 'LG-CHENTAO', 'TG-CT-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属通信电力组，主要负责步话机、电台、电力调度。', '通信电力组', '步话机、电台、电力调度', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, last_login_at, created_at, updated_at) VALUES ('huangxu', 'huangxu', '$2a$10$JSI4MiqXHKw/9NNs2wAcBe/KNoeQ8/fvRMCI6qD1gE/RYA9S41pa2', '黄叙', 'LG-HUANGXU', 'TG-HX-1628', NULL, NULL, '1628 年 D日后登记入册的元老，隶属农业与物资组，主要负责仓储、防霉、红薯试种。', '农业与物资组', '仓储、防霉、红薯试种', 'CHINA', '海南', 1, 'USER', 'ACTIVE', 0, 0, '1628-12-20 18:00:00', '1628-09-24 04:00:00', '1628-12-20 18:00:00') ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE';

-- 用户角色映射
INSERT INTO bbs_user_roles (user_id, role_id)
SELECT u.id, r.id FROM bbs_users u JOIN bbs_roles r ON r.code = u.role
WHERE u.username IN (
  'beiwei',
  'yanquezhi',
  'meiwan',
  'rannyao',
  'guoyi',
  'xuezirang',
  'salina',
  'wude',
  'zhuotianmin',
  'xiaozishan',
  'wendesi',
  'wangluobing',
  'xiyazhou',
  'duwen',
  'jituisi',
  'maqianzhu',
  'duguqiuhun',
  'jiwusheng',
  'zhanwuya',
  'linshenhe',
  'liupan',
  'chentao',
  'huangxu'
) ON DUPLICATE KEY UPDATE user_id = user_id;

-- 清理旧版同名剧情帖，避免重复执行脚本产生重复帖子。
DELETE r FROM bbs_replies r JOIN bbs_threads t ON r.thread_id = t.id WHERE t.title LIKE '【1628·%';
DELETE c FROM bbs_thread_contents c JOIN bbs_threads t ON c.thread_id = t.id WHERE t.title LIKE '【1628·%';
DELETE FROM bbs_threads WHERE title LIKE '【1628·%';

-- 剧情帖子与评论

-- 1. 【1628·D日】博铺港前导侦察与登陆点警戒记录
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·D日】博铺港前导侦察与登陆点警戒记录', (SELECT id FROM bbs_users WHERE username='beiwei'), (SELECT id FROM bbs_categories WHERE slug='security'), 96, 4, 12, 1, 'PUBLISHED', '1628-09-24 09:10:00', '1628-09-24 05:40:00', '1628-09-24 09:10:00');
SET @p1 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p1, '# 博铺港前导侦察与登陆点警戒记录

凌晨圣船抵达后，前导小队先行离船，对博铺港外缘、滩头、通往内陆的小道进行了初步踏查。

## 已确认情况

- 港口附近无成建制武装，但渔户和行脚商人活动痕迹明显。
- 可作为临时哨位的高点有三处，其中北侧椰林后方视野最好。
- 圣船卸载区需要划定警戒线，非施工组人员不得随意进入。

## 建议

1. 夜间建立两班轮换岗哨。
2. 工程组施工区与生活区分开，避免工具和物资散落。
3. 对外口径统一称“海商避风修船”，不要主动暴露来历。

本帖作为 D 日警戒初版记录，各组可补充遗漏。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('治安组同意。建议临时通行证今晚就发，至少把码头、厕所、水源三个区域先分开。', @p1, (SELECT id FROM bbs_users WHERE username='rannyao'), NULL, 1, 4, 'PUBLISHED', '1628-09-24 06:20:00', '1628-09-24 06:20:00');
SET @p1c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('对外口径最好再简化，土著听不懂“避风修船”的细节，统一说“南洋船队上岸采买”。', @p1, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 2, 7, 'PUBLISHED', '1628-09-24 07:05:00', '1628-09-24 07:05:00');
SET @p1c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('收到，外务口径按你这个版本整理到哨位手册里。', @p1, (SELECT id FROM bbs_users WHERE username='beiwei'), @p1c2, 3, 2, 'PUBLISHED', '1628-09-24 07:24:00', '1628-09-24 07:24:00');
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('建议所有扣押、盘问都要有两人以上在场，后面不管是审讯还是交换俘虏，都需要记录。', @p1, (SELECT id FROM bbs_users WHERE username='guoyi'), NULL, 4, 5, 'PUBLISHED', '1628-09-24 09:10:00', '1628-09-24 09:10:00');
SET @p1c3 = LAST_INSERT_ID();

-- 2. 【1628·D日】一号工程浮动码头施工排班
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·D日】一号工程浮动码头施工排班', (SELECT id FROM bbs_users WHERE username='yanquezhi'), (SELECT id FROM bbs_categories WHERE slug='lingao-capital'), 142, 4, 20, 1, 'PUBLISHED', '1628-09-24 10:11:00', '1628-09-24 08:15:00', '1628-09-24 10:11:00');
SET @p2 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p2, '# 一号工程浮动码头施工排班

浮动码头是登陆后所有物资上岸的第一瓶颈，今日先保证“能靠、能卸、能过人”，不要追求一步到位。

## 今日目标

- 完成第一段浮箱固定。
- 铺设临时跳板，宽度以手推车通过为准。
- 设置卸货点编号，避免各组抢同一块岸滩。

## 人手安排

工程组负责结构和固定，后勤组负责绳索、木料和照明，治安组负责警戒。

晚间请各组把损坏工具统一送到码头西侧棚下，我安排人登记。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('港务这边先认领 12 名壮劳力，今晚要把跳板宽度加出来，不然明天公路料下不去。', @p2, (SELECT id FROM bbs_users WHERE username='meiwan'), NULL, 1, 6, 'PUBLISHED', '1628-09-24 09:03:00', '1628-09-24 09:03:00');
SET @p2c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('请把“能过人”改成“能过人且能承受连续手推车通行”，否则验收不通过。', @p2, (SELECT id FROM bbs_users WHERE username='zhuotianmin'), NULL, 2, 9, 'PUBLISHED', '1628-09-24 09:22:00', '1628-09-24 09:22:00');
SET @p2c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('你先别拿现代验收卡我，今天是 D 日，先让物资上岸。', @p2, (SELECT id FROM bbs_users WHERE username='yanquezhi'), @p2c2, 3, 3, 'PUBLISHED', '1628-09-24 09:35:00', '1628-09-24 09:35:00');
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('俘虏和临时雇工后续都会从这里进出，码头编号请和用工登记编号对应。', @p2, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 4, 8, 'PUBLISHED', '1628-09-24 10:11:00', '1628-09-24 10:11:00');
SET @p2c3 = LAST_INSERT_ID();

-- 3. 【1628·D日】第一座现代厕所落成后的防疫提醒
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·D日】第一座现代厕所落成后的防疫提醒', (SELECT id FROM bbs_users WHERE username='liupan'), (SELECT id FROM bbs_categories WHERE slug='medicine'), 88, 3, 11, 0, 'PUBLISHED', '1628-09-24 17:18:00', '1628-09-24 15:30:00', '1628-09-24 17:18:00');
SET @p3 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p3, '# 第一座现代厕所落成后的防疫提醒

厕所剪彩可以热闹，但防疫不能当笑话。

## 从今晚开始执行

- 生活区不得随地排泄。
- 饮用水、洗手水、施工用水分桶标识。
- 粪污坑每日撒灰，医务组负责巡查。
- 厨房与厕所保持距离，任何人不得图省事穿越隔离绳。

临高天气湿热，腹泻一旦扩散，比土著乡勇更麻烦。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('讲习所还没开，先从我们自己人做起。建议每个宿舍贴一张简明版。', @p3, (SELECT id FROM bbs_users WHERE username='duwen'), NULL, 1, 4, 'PUBLISHED', '1628-09-24 16:02:00', '1628-09-24 16:02:00');
SET @p3c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('治安组今晚巡查时顺手看，抓到乱来的先罚清理厕所。', @p3, (SELECT id FROM bbs_users WHERE username='rannyao'), NULL, 2, 6, 'PUBLISHED', '1628-09-24 16:40:00', '1628-09-24 16:40:00');
SET @p3c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('施工队那边最容易脏，给我十张告示，我贴到料场。', @p3, (SELECT id FROM bbs_users WHERE username='meiwan'), NULL, 3, 3, 'PUBLISHED', '1628-09-24 17:18:00', '1628-09-24 17:18:00');
SET @p3c3 = LAST_INSERT_ID();

-- 4. 【1628·D日傍晚】关于郭逸、薛子良、萨琳娜三人登记处理的通报
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·D日傍晚】关于郭逸、薛子良、萨琳娜三人登记处理的通报', (SELECT id FROM bbs_users WHERE username='rannyao'), (SELECT id FROM bbs_categories WHERE slug='security'), 173, 4, 17, 0, 'PUBLISHED', '1628-09-24 20:18:00', '1628-09-24 19:10:00', '1628-09-24 20:18:00');
SET @p4 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p4, '# 关于三名异常人员登记处理的通报

傍晚治安组在外缘巡查时发现三名身份异常人员，已按临时条例进行登记、安置和询问。

经初步确认，三人均属本次穿越人员范围内的意外执法机构成员。考虑到当前营地秩序尚未稳定，暂采取以下办法：

1. 不作为敌对目标处理。
2. 活动范围暂限营地内线。
3. 参与治安、外务和记录工作前需由执委会确认。

请各组不要围观，更不要私下传播夸张版本。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('本人确认配合登记。建议临时条例尽快成文，不要每次都靠口头解释。', @p4, (SELECT id FROM bbs_users WHERE username='guoyi'), NULL, 1, 12, 'PUBLISHED', '1628-09-24 19:25:00', '1628-09-24 19:25:00');
SET @p4c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('补充一句：现场处置没有问题，但登记表需要增加“发现地点”和“见证人”。', @p4, (SELECT id FROM bbs_users WHERE username='xuezirang'), NULL, 2, 8, 'PUBLISHED', '1628-09-24 19:33:00', '1628-09-24 19:33:00');
SET @p4c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('我愿意先帮外务组做语言和接触记录。围观就免了，大家都很忙。', @p4, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 3, 13, 'PUBLISHED', '1628-09-24 20:02:00', '1628-09-24 20:02:00');
SET @p4c3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('收到，明天上午给外务组和治安组一起开短会。', @p4, (SELECT id FROM bbs_users WHERE username='rannyao'), @p4c3, 4, 3, 'PUBLISHED', '1628-09-24 20:18:00', '1628-09-24 20:18:00');

-- 5. 【1628·9月27日】博铺—百仞滩公路施工进度与材料缺口
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·9月27日】博铺—百仞滩公路施工进度与材料缺口', (SELECT id FROM bbs_users WHERE username='meiwan'), (SELECT id FROM bbs_categories WHERE slug='lingao-capital'), 132, 4, 15, 0, 'PUBLISHED', '1628-09-27 20:02:00', '1628-09-27 18:00:00', '1628-09-27 20:02:00');
SET @p5 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p5, '# 博铺—百仞滩公路施工进度与材料缺口

今日开始推进博铺至百仞滩简易道路，目标不是修漂亮路，而是让车辆、畜力和手推车能稳定通过。

## 目前问题

- 软泥段比预计长。
- 木料优先级和码头维修冲突。
- 监理要求过细，施工队认为影响进度。

我的意见：先贯通，再补强。否则百仞城、水电站、供水系统全部卡在路上。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('监理不是拖后腿。软泥段不处理，雨后一烂，你再返工花的时间更多。', @p5, (SELECT id FROM bbs_users WHERE username='zhuotianmin'), NULL, 1, 10, 'PUBLISHED', '1628-09-27 18:25:00', '1628-09-27 18:25:00');
SET @p5c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('建议先定两级标准：军需通行段严一点，普通通行段先过车。', @p5, (SELECT id FROM bbs_users WHERE username='yanquezhi'), NULL, 2, 7, 'PUBLISHED', '1628-09-27 19:05:00', '1628-09-27 19:05:00');
SET @p5c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('劳力调配明早给你 80 人，但必须有明确工分登记，不然俘虏队伍会乱。', @p5, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, 9, 'PUBLISHED', '1628-09-27 19:30:00', '1628-09-27 19:30:00');
SET @p5c3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('要人先到，工分表我让文书跟。', @p5, (SELECT id FROM bbs_users WHERE username='meiwan'), @p5c3, 4, 4, 'PUBLISHED', '1628-09-27 20:02:00', '1628-09-27 20:02:00');

-- 6. 【1628·9月28日】第一批俘虏分组管理试行办法
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·9月28日】第一批俘虏分组管理试行办法', (SELECT id FROM bbs_users WHERE username='wude'), (SELECT id FROM bbs_categories WHERE slug='governance'), 156, 4, 22, 1, 'PUBLISHED', '1628-09-28 12:30:00', '1628-09-28 10:20:00', '1628-09-28 12:30:00');
SET @p6 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p6, '# 第一批俘虏分组管理试行办法

俘虏不是简单的“看押对象”，也是我们认识本地社会、建立劳动秩序的第一批样本。

## 试行原则

1. 分组而不混管，避免原有首领继续控制众人。
2. 轻重劳动分开，表现好的优先给稳定口粮。
3. 每日点名、工分、奖惩三张表必须对应。
4. 不许私刑，不许私下交换物品。

后续如果释放部分人员返乡，也必须让他们带着“临高人做事有章法”的印象回去。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('支持“不许私刑”。如果要长期立规矩，第一批案例最关键。', @p6, (SELECT id FROM bbs_users WHERE username='guoyi'), NULL, 1, 14, 'PUBLISHED', '1628-09-28 10:44:00', '1628-09-28 10:44:00');
SET @p6c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('讲习所可以提前准备最简单的口号和数字教学，工分制度要让他们听懂。', @p6, (SELECT id FROM bbs_users WHERE username='duwen'), NULL, 2, 8, 'PUBLISHED', '1628-09-28 11:20:00', '1628-09-28 11:20:00');
SET @p6c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('看押压力很大。请政务组给出逃跑、打架、盗窃三种情况的处理标准。', @p6, (SELECT id FROM bbs_users WHERE username='rannyao'), NULL, 3, 9, 'PUBLISHED', '1628-09-28 12:05:00', '1628-09-28 12:05:00');
SET @p6c3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('今晚补一版附表，治安组先按轻重分级登记，不要现场自由裁量太大。', @p6, (SELECT id FROM bbs_users WHERE username='wude'), @p6c3, 4, 5, 'PUBLISHED', '1628-09-28 12:30:00', '1628-09-28 12:30:00');

-- 7. 【1628·10月1日】百仞城、水电站与供水系统选址意见
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·10月1日】百仞城、水电站与供水系统选址意见', (SELECT id FROM bbs_users WHERE username='zhuotianmin'), (SELECT id FROM bbs_categories WHERE slug='industry'), 121, 3, 11, 0, 'PUBLISHED', '1628-10-01 11:10:00', '1628-10-01 09:00:00', '1628-10-01 11:10:00');
SET @p7 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p7, '# 百仞城、水电站与供水系统选址意见

博铺到百仞滩简易公路即将贯通，下一步应避免“哪里空就往哪里摆”的随意建设。

## 建议优先级

- 百仞城生活区：先解决居住、防火、排水。
- 200KW 水电站：先做可运行方案，不追求满负荷。
- 供水系统：水源保护比管线漂亮更重要。

请各组提交“必须靠近水源”“必须靠近道路”“必须远离居民区”的需求清单。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('道路晚了一天，我认。但你这个清单今天就要，我怕各组明天又抢地。', @p7, (SELECT id FROM bbs_users WHERE username='meiwan'), NULL, 1, 6, 'PUBLISHED', '1628-10-01 09:40:00', '1628-10-01 09:40:00');
SET @p7c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('电站和通信机房最好留出干燥高地，不要把电台放到容易回潮的地方。', @p7, (SELECT id FROM bbs_users WHERE username='chentao'), NULL, 2, 7, 'PUBLISHED', '1628-10-01 10:15:00', '1628-10-01 10:15:00');
SET @p7c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('医务点必须上风、排水好、离厕所远。别等发热病人出现再改。', @p7, (SELECT id FROM bbs_users WHERE username='liupan'), NULL, 3, 6, 'PUBLISHED', '1628-10-01 11:10:00', '1628-10-01 11:10:00');
SET @p7c3 = LAST_INSERT_ID();

-- 8. 【1628·10月初】临高内网与外驻电报临时通信方案
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·10月初】临高内网与外驻电报临时通信方案', (SELECT id FROM bbs_users WHERE username='chentao'), (SELECT id FROM bbs_categories WHERE slug='communications'), 148, 3, 18, 0, 'PUBLISHED', '1628-10-02 15:40:00', '1628-10-02 14:00:00', '1628-10-02 15:40:00');
SET @p8 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p8, '# 临高内网与外驻电报临时通信方案

目前联络分两套：临高内驻使用内部设备和值班传令，外驻或远行人员按驻外档案、约定时刻和电台值守联系。

## 临高内网

- 覆盖：登陆点、博铺港、百仞城施工区。
- 用途：调度、警报、医务紧急呼叫。
- 禁止：闲聊占用频道、传播未确认消息。

## 外驻电报

广州、台湾、日本、越南等外点将来统一走电报格式，称呼使用电报号，不在明文中写真实姓名。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('广州行需要一套短码表，尤其是货物、银钱、危险三个类别。', @p8, (SELECT id FROM bbs_users WHERE username='xiaozishan'), NULL, 1, 8, 'PUBLISHED', '1628-10-02 14:35:00', '1628-10-02 14:35:00');
SET @p8c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('外务文本还要考虑被土著翻译误读，建议电报码和口头说辞分开。', @p8, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 2, 9, 'PUBLISHED', '1628-10-02 15:10:00', '1628-10-02 15:10:00');
SET @p8c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('警报频道必须单独留出来，反围剿前后不能因为闲聊耽误。', @p8, (SELECT id FROM bbs_users WHERE username='beiwei'), NULL, 3, 6, 'PUBLISHED', '1628-10-02 15:40:00', '1628-10-02 15:40:00');
SET @p8c3 = LAST_INSERT_ID();

-- 9. 【1628·10月9日】第一次反围剿战后检讨提纲
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·10月9日】第一次反围剿战后检讨提纲', (SELECT id FROM bbs_users WHERE username='rannyao'), (SELECT id FROM bbs_categories WHERE slug='security'), 260, 4, 31, 1, 'PUBLISHED', '1628-10-09 23:16:00', '1628-10-09 22:20:00', '1628-10-09 23:16:00');
SET @p9 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p9, '# 第一次反围剿战后检讨提纲

今日打退土著乡勇两路进攻，结果可以接受，但过程暴露的问题必须当晚处理。

## 需要复盘

1. 预警链条是否过长。
2. 临时防线的射界是否被施工堆料遮挡。
3. 俘虏安置点是否靠近危险区域。
4. 医务、后勤、弹药补给是否有统一呼叫方式。

扩大会议请各组只讲事实，不要抢功。明天上午治安组开始审讯俘虏，政务组请派人旁听。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('我补一条：哨位撤换记录不完整，有两个岗不知道上一班看到过什么。', @p9, (SELECT id FROM bbs_users WHERE username='beiwei'), NULL, 1, 14, 'PUBLISHED', '1628-10-09 22:38:00', '1628-10-09 22:38:00');
SET @p9c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('医务组需要固定担架路线，今天有一段被木料堵住。', @p9, (SELECT id FROM bbs_users WHERE username='liupan'), NULL, 2, 11, 'PUBLISHED', '1628-10-09 22:50:00', '1628-10-09 22:50:00');
SET @p9c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('审讯明早开始，我带两名记录员，所有口供按姓名、村寨、关系网分类。', @p9, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, 15, 'PUBLISHED', '1628-10-09 23:05:00', '1628-10-09 23:05:00');
SET @p9c3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('同意。审讯地点设在内线，不让围观。', @p9, (SELECT id FROM bbs_users WHERE username='rannyao'), @p9c3, 4, 7, 'PUBLISHED', '1628-10-09 23:16:00', '1628-10-09 23:16:00');

-- 10. 【1628·10月13日】审俘纪要摘要与劳动分派表
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·10月13日】审俘纪要摘要与劳动分派表', (SELECT id FROM bbs_users WHERE username='wude'), (SELECT id FROM bbs_categories WHERE slug='governance'), 190, 3, 23, 0, 'PUBLISHED', '1628-10-13 10:12:00', '1628-10-13 08:30:00', '1628-10-13 10:12:00');
SET @p10 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p10, '# 审俘纪要摘要与劳动分派表

通宵审讯结束，俘虏信息已初步整理。今日开始按体力、技能、村寨关系分派劳动。

## 劳动方向

- 砖瓦：需要体力，便于集中管理。
- 水泥：需要严格防护，优先选服从性好的。
- 木炭：可安排在外缘，但必须有治安组巡查。

《临高快讯》可刊登删节版，重点是让全体元老知道本地乡勇组织方式，而不是猎奇。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('删节版请留出“为什么要分工分组”的解释，群众工作以后也要用。', @p10, (SELECT id FROM bbs_users WHERE username='duwen'), NULL, 1, 9, 'PUBLISHED', '1628-10-13 09:02:00', '1628-10-13 09:02:00');
SET @p10c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('木炭组能不能拨一部分给农业棚？夜间烘干种薯需要稳定燃料。', @p10, (SELECT id FROM bbs_users WHERE username='huangxu'), NULL, 2, 5, 'PUBLISHED', '1628-10-13 09:40:00', '1628-10-13 09:40:00');
SET @p10c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('审俘纪要公开时注意保护个别愿意合作的人，不要让他们回乡后被报复。', @p10, (SELECT id FROM bbs_users WHERE username='guoyi'), NULL, 3, 13, 'PUBLISHED', '1628-10-13 10:12:00', '1628-10-13 10:12:00');
SET @p10c3 = LAST_INSERT_ID();

-- 11. 【1628·10月15日】南海模范示范农庄建庄任务
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·10月15日】南海模范示范农庄建庄任务', (SELECT id FROM bbs_users WHERE username='xiyazhou'), (SELECT id FROM bbs_categories WHERE slug='agriculture'), 128, 3, 18, 0, 'PUBLISHED', '1628-10-15 17:40:00', '1628-10-15 16:00:00', '1628-10-15 17:40:00');
SET @p11 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p11, '# 南海模范示范农庄建庄任务

议和之后，农业工作不能只停留在“有地可种”。示范农庄要承担三件事：生产、展示、训练。

## 第一阶段任务

- 清点可用农具和种子。
- 建立小块试验田，记录土壤、水源和虫害。
- 组织归化民参与，让他们看到“按规矩干活能吃饱”。

农庄不是摆样子的，它要成为后续基层政权和粮食安全的起点。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('仓储这边先给你留一批干燥竹筐，种子别直接堆地上。', @p11, (SELECT id FROM bbs_users WHERE username='huangxu'), NULL, 1, 8, 'PUBLISHED', '1628-10-15 16:22:00', '1628-10-15 16:22:00');
SET @p11c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('讲习所可以和农庄联动，上午识字，下午下地，效果会更直观。', @p11, (SELECT id FROM bbs_users WHERE username='duwen'), NULL, 2, 10, 'PUBLISHED', '1628-10-15 17:04:00', '1628-10-15 17:04:00');
SET @p11c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('工分制度会同步试点，但不要让农庄变成单纯惩罚性劳动场。', @p11, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, 9, 'PUBLISHED', '1628-10-15 17:40:00', '1628-10-15 17:40:00');
SET @p11c3 = LAST_INSERT_ID();

-- 12. 【1628·11月1日】登瀛洲号抵达广州与先遣站纪律
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·11月1日】登瀛洲号抵达广州与先遣站纪律', (SELECT id FROM bbs_users WHERE username='xiaozishan'), (SELECT id FROM bbs_categories WHERE slug='guangzhou-station'), 244, 4, 27, 1, 'PUBLISHED', '1628-11-01 21:30:00', '1628-11-01 20:00:00', '1628-11-01 21:30:00');
SET @p12 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p12, '# 登瀛洲号抵达广州与先遣站纪律

三等运输舰“登瀛洲”号已抵达广州南城外码头，先遣站开始运作。

## 纪律要求

1. 不暴露临高核心设备和真实产能。
2. 对外交易先保守，不追求一次赚够。
3. 任何与地方胥吏、牙行、船户的接触都要登记。
4. 涉及人员安全事件，立即用电报格式回报。

广州不是临高，这里消息传得比海风还快。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('外务口径我会重写成广州版，不提“元老院”，只说南洋船队。', @p12, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 1, 12, 'PUBLISHED', '1628-11-01 20:16:00', '1628-11-01 20:16:00');
SET @p12c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('先遣站账目请单独记，回临高后要给执委会做总结。', @p12, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 2, 7, 'PUBLISHED', '1628-11-01 20:50:00', '1628-11-01 20:50:00');
SET @p12c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('发生非礼未遂一类事件必须留证，不要为了交易忍气吞声。', @p12, (SELECT id FROM bbs_users WHERE username='rannyao'), NULL, 3, 11, 'PUBLISHED', '1628-11-01 21:12:00', '1628-11-01 21:12:00');
SET @p12c3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('已列为先遣站红线，相关人员不得单独外出。', @p12, (SELECT id FROM bbs_users WHERE username='xiaozishan'), @p12c3, 4, 6, 'PUBLISHED', '1628-11-01 21:30:00', '1628-11-01 21:30:00');

-- 13. 【1628·11月6日】盐场村初访：工作队观察笔记
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·11月6日】盐场村初访：工作队观察笔记', (SELECT id FROM bbs_users WHERE username='wangluobing'), (SELECT id FROM bbs_categories WHERE slug='agriculture'), 151, 3, 15, 0, 'PUBLISHED', '1628-11-06 21:04:00', '1628-11-06 19:30:00', '1628-11-06 21:04:00');
SET @p13 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p13, '# 盐场村初访：工作队观察笔记

今日带工作队进入盐场村，先不急着开大会，主要看人、看盐、看债。

## 初步观察

- 村内盐户对外来力量既怕又好奇。
- 旧有头面人物仍能影响分配。
- 粮食和盐的交换关系，比口号更能决定他们听不听我们说话。

建议后续发动群众时，不要只讲新制度，要先解决“谁能活到下个月”的问题。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('明天我和杜雯过去，先建小组，不急着挂牌。', @p13, (SELECT id FROM bbs_users WHERE username='xiyazhou'), NULL, 1, 9, 'PUBLISHED', '1628-11-06 20:02:00', '1628-11-06 20:02:00');
SET @p13c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('讲习所名字可以先定“马袅农民讲习所”，但课程要从算账和识字开始。', @p13, (SELECT id FROM bbs_users WHERE username='duwen'), NULL, 2, 10, 'PUBLISHED', '1628-11-06 20:30:00', '1628-11-06 20:30:00');
SET @p13c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('基层政权要试，但别让村民觉得只是换一批收税的人。', @p13, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, 12, 'PUBLISHED', '1628-11-06 21:04:00', '1628-11-06 21:04:00');
SET @p13c3 = LAST_INSERT_ID();

-- 14. 【1628·11月8日】马袅农民讲习所筹备清单
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·11月8日】马袅农民讲习所筹备清单', (SELECT id FROM bbs_users WHERE username='duwen'), (SELECT id FROM bbs_categories WHERE slug='governance'), 133, 3, 19, 0, 'PUBLISHED', '1628-11-08 19:12:00', '1628-11-08 17:20:00', '1628-11-08 19:12:00');
SET @p14 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p14, '# 马袅农民讲习所筹备清单

讲习所不是现代学校的复制品，而是基层政权的第一块木桩。

## 第一批课程

- 数字和工分。
- 盐、粮、债的简单账。
- 卫生和饮水。
- 为什么要排队、登记、按工分领粮。

我们先用他们听得懂的事讲规矩，再慢慢讲组织。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('可以。讲习所旁边留一块公告板，把每日工分公开贴出来。', @p14, (SELECT id FROM bbs_users WHERE username='xiyazhou'), NULL, 1, 7, 'PUBLISHED', '1628-11-08 18:00:00', '1628-11-08 18:00:00');
SET @p14c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('卫生课请加洗手和井水保护，盐场村孩子腹泻不少。', @p14, (SELECT id FROM bbs_users WHERE username='liupan'), NULL, 2, 8, 'PUBLISHED', '1628-11-08 18:40:00', '1628-11-08 18:40:00');
SET @p14c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('这个经验后面要写成制度模板，不能只靠你们个人发挥。', @p14, (SELECT id FROM bbs_users WHERE username='maqianzhu'), NULL, 3, 10, 'PUBLISHED', '1628-11-08 19:12:00', '1628-11-08 19:12:00');
SET @p14c3 = LAST_INSERT_ID();

-- 15. 【1628·11月11日】第一次黎区探险返回简报
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·11月11日】第一次黎区探险返回简报', (SELECT id FROM bbs_users WHERE username='wendesi'), (SELECT id FROM bbs_categories WHERE slug='li-area'), 168, 3, 21, 0, 'PUBLISHED', '1628-11-11 22:10:00', '1628-11-11 21:10:00', '1628-11-11 22:10:00');
SET @p15 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p15, '# 第一次黎区探险返回简报

黎区探险队已返回基地。释放随行的黎族俘虏后，我们与那南峒建立了初步联系。

## 收获

- 初步确认山路、水源和可交易物品。
- 随行人员证明“放人回去”比单纯押解更有效。
- 黎区内部关系复杂，不能把所有人都当成同一类土著。

后续建议以医疗、盐、铁器和信誉作为接触起点。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('外务组需要你们整理称呼、禁忌和礼物清单，不要让下一队犯低级错误。', @p15, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 1, 8, 'PUBLISHED', '1628-11-11 21:33:00', '1628-11-11 21:33:00');
SET @p15c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('医疗接触可以做，但药品不能乱发，剂量和记录必须跟上。', @p15, (SELECT id FROM bbs_users WHERE username='liupan'), NULL, 2, 9, 'PUBLISHED', '1628-11-11 21:50:00', '1628-11-11 21:50:00');
SET @p15c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('这件事证明释放俘虏不是软弱，是有条件的政治投资。', @p15, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, 11, 'PUBLISHED', '1628-11-11 22:10:00', '1628-11-11 22:10:00');
SET @p15c3 = LAST_INSERT_ID();

-- 16. 【1628·11月12日】铵木炸药试制成功及储存警告
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·11月12日】铵木炸药试制成功及储存警告', (SELECT id FROM bbs_users WHERE username='jituisi'), (SELECT id FROM bbs_categories WHERE slug='industry'), 205, 3, 26, 0, 'PUBLISHED', '1628-11-12 16:45:00', '1628-11-12 15:30:00', '1628-11-12 16:45:00');
SET @p16 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p16, '# 铵木炸药试制成功及储存警告

铵木炸药小样试制成功，但请所有人记住：成功不等于可以随便用。

## 安全边界

- 原料、混合、储存、运输分人负责。
- 任何试爆都要治安组封锁现场。
- 不允许私人保存样品。
- 施工爆破必须提前一天报备。

化工组不会给任何“我就看看”的人开绿灯。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('军务安保只接收登记封存后的成品，谁私拿我就按危险品处理。', @p16, (SELECT id FROM bbs_users WHERE username='beiwei'), NULL, 1, 14, 'PUBLISHED', '1628-11-12 15:58:00', '1628-11-12 15:58:00');
SET @p16c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('道路和采石会用到，但请给出最小安全距离和哑炮处理流程。', @p16, (SELECT id FROM bbs_users WHERE username='zhuotianmin'), NULL, 2, 9, 'PUBLISHED', '1628-11-12 16:20:00', '1628-11-12 16:20:00');
SET @p16c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('冶金组附近不要存放，炉火、火星、煤粉都多。', @p16, (SELECT id FROM bbs_users WHERE username='jiwusheng'), NULL, 3, 7, 'PUBLISHED', '1628-11-12 16:45:00', '1628-11-12 16:45:00');
SET @p16c3 = LAST_INSERT_ID();

-- 17. 【1628·11月28日】东门市建设与治安打非行动安排
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·11月28日】东门市建设与治安打非行动安排', (SELECT id FROM bbs_users WHERE username='duguqiuhun'), (SELECT id FROM bbs_categories WHERE slug='security'), 140, 3, 16, 0, 'PUBLISHED', '1628-11-28 19:22:00', '1628-11-28 18:10:00', '1628-11-28 19:22:00');
SET @p17 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p17, '# 东门市建设与治安打非行动安排

东门市开始建设，派出所同步成立。市场一旦有了人流，偷盗、赌博、私卖、冒名登记都会跟着来。

## 本周行动

1. 摊位登记，不登记不得交易。
2. 夜间巡逻，两人一组。
3. 对强买强卖、敲诈勒索和私藏武器从严处理。
4. 归化民纠纷先调解，恶性事件移交治安组。

东门市不是旧集市，它要成为临高秩序的样板。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('派出所需要保留案卷编号，后续可以形成第一批判例。', @p17, (SELECT id FROM bbs_users WHERE username='guoyi'), NULL, 1, 8, 'PUBLISHED', '1628-11-28 18:34:00', '1628-11-28 18:34:00');
SET @p17c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('市场秩序和工分制度要打通，不能让偷懒的人靠投机过得更好。', @p17, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 2, 10, 'PUBLISHED', '1628-11-28 19:00:00', '1628-11-28 19:00:00');
SET @p17c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('外来商人进入东门市也要登记来处，外务组可以设计简表。', @p17, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 3, 6, 'PUBLISHED', '1628-11-28 19:22:00', '1628-11-28 19:22:00');
SET @p17c3 = LAST_INSERT_ID();

-- 18. 【1628·12月初】第一次广州行总结：贸易、风险与后续站点
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·12月初】第一次广州行总结：贸易、风险与后续站点', (SELECT id FROM bbs_users WHERE username='xiaozishan'), (SELECT id FROM bbs_categories WHERE slug='navigation'), 184, 3, 24, 0, 'PUBLISHED', '1628-12-01 21:15:00', '1628-12-01 20:00:00', '1628-12-01 21:15:00');
SET @p18 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p18, '# 第一次广州行总结：贸易、风险与后续站点

广州行证明外部市场可以利用，但风险同样真实。

## 可继续推进

- 小批量、低暴露的商品交换。
- 牙行关系分散，不押注单一中介。
- 先遣站人员定期轮换，避免被地方势力摸透。

## 暂缓事项

- 大规模展示技术物品。
- 与官府深度绑定。
- 未经审批的私人贸易。

临高需要广州，但不能让广州牵着临高走。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('请把这次总结整理成计划委员会附件，后续预算要有依据。', @p18, (SELECT id FROM bbs_users WHERE username='maqianzhu'), NULL, 1, 9, 'PUBLISHED', '1628-12-01 20:20:00', '1628-12-01 20:20:00');
SET @p18c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('非礼未遂事件必须写入纪律案例，别只写贸易收益。', @p18, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 2, 12, 'PUBLISHED', '1628-12-01 20:50:00', '1628-12-01 20:50:00');
SET @p18c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('释放俘虏、广州站、黎区联络，本质都是同一件事：我们要学会和旧世界打交道。', @p18, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, 13, 'PUBLISHED', '1628-12-01 21:15:00', '1628-12-01 21:15:00');
SET @p18c3 = LAST_INSERT_ID();

-- 19. 【1628·12月6日】第一次临高角海战战果通报
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·12月6日】第一次临高角海战战果通报', (SELECT id FROM bbs_users WHERE username='beiwei'), (SELECT id FROM bbs_categories WHERE slug='security'), 310, 4, 40, 1, 'PUBLISHED', '1628-12-06 21:00:00', '1628-12-06 19:45:00', '1628-12-06 21:00:00');
SET @p19 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p19, '# 第一次临高角海战战果通报

今日临高角方向发生海上接触，敌方伪装伏击失败。我方击沉海盗船两艘，俘获海盗十八名，并缴获一艘双桅快船。

## 需要立刻处理

1. 俘虏分开审讯，确认是否与诸彩老部有关。
2. 快船先封存，船体检查后再决定改装。
3. 港口夜间警戒加倍，防止后续试探。
4. 不得在营地内夸大战果，避免轻敌。

胜利说明我们能守住海口，但也说明旧世界已经注意到我们。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('俘虏已经分组，今晚开始第一轮问话。', @p19, (SELECT id FROM bbs_users WHERE username='rannyao'), NULL, 1, 14, 'PUBLISHED', '1628-12-06 20:02:00', '1628-12-06 20:02:00');
SET @p19c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('那艘快船有用，航海组申请参与检查，别急着拆。', @p19, (SELECT id FROM bbs_users WHERE username='xiaozishan'), NULL, 2, 13, 'PUBLISHED', '1628-12-06 20:20:00', '1628-12-06 20:20:00');
SET @p19c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('公报口径要克制，重点写警戒和制度，不写传奇故事。', @p19, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, 11, 'PUBLISHED', '1628-12-06 20:45:00', '1628-12-06 20:45:00');
SET @p19c3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('同意，明早给执委会交正式版。', @p19, (SELECT id FROM bbs_users WHERE username='beiwei'), @p19c3, 4, 6, 'PUBLISHED', '1628-12-06 21:00:00', '1628-12-06 21:00:00');

-- 20. 【1628·12月15日】简易船坞与伏波号改装清单
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·12月15日】简易船坞与伏波号改装清单', (SELECT id FROM bbs_users WHERE username='wude'), (SELECT id FROM bbs_categories WHERE slug='navigation'), 176, 3, 19, 0, 'PUBLISHED', '1628-12-15 11:40:00', '1628-12-15 10:00:00', '1628-12-15 11:40:00');
SET @p20 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p20, '# 简易船坞与伏波号改装清单

简易船坞建设启动，目标是在一周内完成对缴获双桅快船的基础维护和改装，并命名为“伏波号”。

## 改装重点

- 船体补漏和桅索检查。
- 增设简单火力平台。
- 仓位重新划分，便于临高—广州短途运输。
- 船员训练和纪律表同步制定。

这不是一艘漂亮船，而是一艘必须能用、能跑、能活着回来的船。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('航海组认领船员训练，伏波号不能只靠胆子出海。', @p20, (SELECT id FROM bbs_users WHERE username='xiaozishan'), NULL, 1, 10, 'PUBLISHED', '1628-12-15 10:30:00', '1628-12-15 10:30:00');
SET @p20c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('火力平台别超重，先给我船体承重数据。', @p20, (SELECT id FROM bbs_users WHERE username='zhanwuya'), NULL, 2, 7, 'PUBLISHED', '1628-12-15 11:05:00', '1628-12-15 11:05:00');
SET @p20c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('船坞木料和道路维修又冲突了。请执委会定优先级，不要让我两头挨骂。', @p20, (SELECT id FROM bbs_users WHERE username='meiwan'), NULL, 3, 12, 'PUBLISHED', '1628-12-15 11:40:00', '1628-12-15 11:40:00');
SET @p20c3 = LAST_INSERT_ID();

-- 21. 【1628·12月16日】计划委员会1628第31号文件草案
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·12月16日】计划委员会1628第31号文件草案', (SELECT id FROM bbs_users WHERE username='maqianzhu'), (SELECT id FROM bbs_categories WHERE slug='senate'), 288, 3, 36, 1, 'PUBLISHED', '1628-12-16 10:50:00', '1628-12-16 09:00:00', '1628-12-16 10:50:00');
SET @p21 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p21, '# 计划委员会 1628 第31号文件草案

本草案用于讨论劳工制度第二次改革、军事委员会调整以及新军筹备事项。

## 核心意见

1. 劳工制度从“临时分派”转向“工分、技能、纪律三表合一”。
2. 军事委员会不再只处理临时防卫，应承担训练、装备、情报和动员。
3. 新军筹备先从归化民骨干、盐场村积极分子和可靠俘虏中筛选。
4. 各部门提交人力需求时必须写清楚：需要多少人、为什么、训练多久。

请各组在三日内回复意见。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('支持三表合一。没有制度化用工，后面所有建设都会被人力问题拖住。', @p21, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 1, 16, 'PUBLISHED', '1628-12-16 09:28:00', '1628-12-16 09:28:00');
SET @p21c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('新军筹备要慢，忠诚、纪律、训练都要过关，不能只看体格。', @p21, (SELECT id FROM bbs_users WHERE username='beiwei'), NULL, 2, 15, 'PUBLISHED', '1628-12-16 10:05:00', '1628-12-16 10:05:00');
SET @p21c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('归化民骨干从讲习所里挑会更稳，他们至少知道我们为什么要这些规矩。', @p21, (SELECT id FROM bbs_users WHERE username='duwen'), NULL, 3, 11, 'PUBLISHED', '1628-12-16 10:50:00', '1628-12-16 10:50:00');
SET @p21c3 = LAST_INSERT_ID();

-- 22. 【1628·12月15日夜】炼钢炉第一次稳定出钢记录
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·12月15日夜】炼钢炉第一次稳定出钢记录', (SELECT id FROM bbs_users WHERE username='jiwusheng'), (SELECT id FROM bbs_categories WHERE slug='industry'), 162, 3, 22, 0, 'PUBLISHED', '1628-12-16 00:10:00', '1628-12-15 22:40:00', '1628-12-16 00:10:00');
SET @p22 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p22, '# 炼钢炉第一次稳定出钢记录

今晚炼钢炉实现一次相对稳定出钢。质量距离理想状态还远，但已经足够说明路线可行。

## 问题

- 炉温波动明显。
- 原料杂质控制不稳定。
- 操作人员经验不足，记录表需要细化。

冶金组需要化工、机械和兵工三方继续配合。别急着问能不能量产，先问下一炉能不能更稳。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('化工组可以协助燃料和助熔剂记录，但你们要把温度估算表写清楚。', @p22, (SELECT id FROM bbs_users WHERE username='jituisi'), NULL, 1, 9, 'PUBLISHED', '1628-12-15 23:05:00', '1628-12-15 23:05:00');
SET @p22c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('兵工这边先不催量，稳定性比数量重要。枪管材料不能赌运气。', @p22, (SELECT id FROM bbs_users WHERE username='wangluobing'), NULL, 2, 12, 'PUBLISHED', '1628-12-15 23:30:00', '1628-12-15 23:30:00');
SET @p22c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('铸炮需要另一套标准，别把枪管和炮管混在一个验收口径里。', @p22, (SELECT id FROM bbs_users WHERE username='zhanwuya'), NULL, 3, 8, 'PUBLISHED', '1628-12-16 00:10:00', '1628-12-16 00:10:00');
SET @p22c3 = LAST_INSERT_ID();

-- 23. 【1628·12月18日】线膛枪与米尼弹试制协同表
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·12月18日】线膛枪与米尼弹试制协同表', (SELECT id FROM bbs_users WHERE username='wangluobing'), (SELECT id FROM bbs_categories WHERE slug='industry'), 225, 3, 31, 0, 'PUBLISHED', '1628-12-18 18:30:00', '1628-12-18 17:20:00', '1628-12-18 18:30:00');
SET @p23 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p23, '# 线膛枪与米尼弹试制协同表

雷汞试制成功后，兵工组开始推进线膛枪和米尼弹样品。请注意，样品成功不是列装成功。

## 协同需求

- 化工组：底火稳定性和保存条件。
- 冶金组：枪管材料批次记录。
- 机械组：膛线加工工装和检测夹具。
- 军务组：试射场地、封锁和记录。

每一次试射都要留下数据，不要只留下“感觉威力不错”。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('雷汞不是玩具，底火保存条件必须按我的清单来。', @p23, (SELECT id FROM bbs_users WHERE username='jituisi'), NULL, 1, 13, 'PUBLISHED', '1628-12-18 17:40:00', '1628-12-18 17:40:00');
SET @p23c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('膛线工装还要调，我不保证第一批合格率。', @p23, (SELECT id FROM bbs_users WHERE username='zhanwuya'), NULL, 2, 9, 'PUBLISHED', '1628-12-18 18:05:00', '1628-12-18 18:05:00');
SET @p23c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('试射由军务组封场，未经批准不得围观。', @p23, (SELECT id FROM bbs_users WHERE username='beiwei'), NULL, 3, 11, 'PUBLISHED', '1628-12-18 18:30:00', '1628-12-18 18:30:00');
SET @p23c3 = LAST_INSERT_ID();

-- 24. 【1628·12月20日】玻璃攻关小组立项与原料需求
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·12月20日】玻璃攻关小组立项与原料需求', (SELECT id FROM bbs_users WHERE username='jituisi'), (SELECT id FROM bbs_categories WHERE slug='industry'), 146, 3, 17, 0, 'PUBLISHED', '1628-12-20 12:20:00', '1628-12-20 11:00:00', '1628-12-20 12:20:00');
SET @p24 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p24, '# 玻璃攻关小组立项与原料需求

化工、机械、冶金三组抽调人员，成立玻璃攻关小组。目标先不是高档玻璃，而是能稳定做出可用玻璃器皿和观察窗。

## 需要支持

- 石英砂来源。
- 燃料和炉温控制。
- 坩埚材料。
- 失败样品的记录与回收。

玻璃会影响医务、化工、教育和工业测量，请不要把它当成装饰品项目。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('医务组需要试管、药瓶和简单观察片，哪怕质量一般也比没有强。', @p24, (SELECT id FROM bbs_users WHERE username='liupan'), NULL, 1, 8, 'PUBLISHED', '1628-12-20 11:25:00', '1628-12-20 11:25:00');
SET @p24c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('炉温控制可以借冶金组经验，但不要跟炼钢抢同一个班组。', @p24, (SELECT id FROM bbs_users WHERE username='jiwusheng'), NULL, 2, 7, 'PUBLISHED', '1628-12-20 12:00:00', '1628-12-20 12:00:00');
SET @p24c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('立项通过后请给出三阶段目标：能出样、能复现、能小批量。', @p24, (SELECT id FROM bbs_users WHERE username='maqianzhu'), NULL, 3, 10, 'PUBLISHED', '1628-12-20 12:20:00', '1628-12-20 12:20:00');
SET @p24c3 = LAST_INSERT_ID();

-- 25. 【1628·12月20日】第一批高产脱毒红薯下种记录
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【1628·12月20日】第一批高产脱毒红薯下种记录', (SELECT id FROM bbs_users WHERE username='huangxu'), (SELECT id FROM bbs_categories WHERE slug='agriculture'), 198, 3, 29, 0, 'PUBLISHED', '1628-12-20 18:00:00', '1628-12-20 16:30:00', '1628-12-20 18:00:00');
SET @p25 = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p25, '# 第一批高产脱毒红薯下种记录

今日第一批高产脱毒红薯完成下种。数量不大，但意义很大：这是我们把现代农业真正落到土地上的第一步。

## 记录事项

- 试验田分三块，分别记录土壤湿度、遮阴和施肥差异。
- 种苗来源、切块大小和下种间距已登记。
- 设专人防盗、防踩踏、防误拔。

请各组不要把试验田当参观点，想看可以，先登记。') ON DUPLICATE KEY UPDATE content=VALUES(content);
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('农庄这边配合看护。丰收之前，先把“记录”二字刻进大家脑子里。', @p25, (SELECT id FROM bbs_users WHERE username='xiyazhou'), NULL, 1, 12, 'PUBLISHED', '1628-12-20 16:55:00', '1628-12-20 16:55:00');
SET @p25c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('以后讲习所可以拿红薯田当教材：为什么要按规矩种，为什么要记数。', @p25, (SELECT id FROM bbs_users WHERE username='duwen'), NULL, 2, 9, 'PUBLISHED', '1628-12-20 17:20:00', '1628-12-20 17:20:00');
SET @p25c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('如果后续作为主粮推广，医务组会配合记录营养和腹泻情况。', @p25, (SELECT id FROM bbs_users WHERE username='liupan'), NULL, 3, 8, 'PUBLISHED', '1628-12-20 18:00:00', '1628-12-20 18:00:00');
SET @p25c3 = LAST_INSERT_ID();

-- 统计字段回填
UPDATE bbs_threads t
SET comment_count = (SELECT COUNT(*) FROM bbs_replies r WHERE r.thread_id = t.id),
    last_replied_at = COALESCE((SELECT MAX(r.created_at) FROM bbs_replies r WHERE r.thread_id = t.id), t.created_at),
    updated_at = COALESCE((SELECT MAX(r.created_at) FROM bbs_replies r WHERE r.thread_id = t.id), t.updated_at)
WHERE t.title LIKE '【1628·%';

UPDATE bbs_categories c
SET thread_count = (SELECT COUNT(*) FROM bbs_threads t WHERE t.category_id = c.id AND t.status = 'PUBLISHED');

UPDATE bbs_users u
SET post_count = (SELECT COUNT(*) FROM bbs_threads t WHERE t.author_id = u.id AND t.status = 'PUBLISHED'),
    reply_count = (SELECT COUNT(*) FROM bbs_replies r WHERE r.author_id = u.id AND r.status = 'PUBLISHED');

-- 分区负责人：默认让相关剧情角色负责对应板块，后台可再改。
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='maqianzhu') WHERE c.slug='senate';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='meiwan') WHERE c.slug='lingao-capital';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='jiwusheng') WHERE c.slug='industry';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='xiyazhou') WHERE c.slug='agriculture';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='liupan') WHERE c.slug='medicine';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='beiwei') WHERE c.slug='security';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='xiaozishan') WHERE c.slug='navigation';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='chentao') WHERE c.slug='communications';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='wude') WHERE c.slug='governance';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='wendesi') WHERE c.slug='li-area';
UPDATE bbs_categories c SET manager_user_id = (SELECT id FROM bbs_users WHERE username='xiaozishan') WHERE c.slug='guangzhou-station';

SELECT '1628 年剧情种子数据已导入：用户、分区、帖子、评论均已写入。所有新用户默认密码为 123456。' AS result;


-- 继续导入维基人物列表里的元老账号和额外剧情帖。
SOURCE D:/github/modern-bbs/docs/seed-1628-wiki-elders-extra.sql;
