-- 启明元老院 D日—D+95日演示数据：用户、帖子、评论区、楼中回复
-- 默认演示用户密码：123456
-- 使用前请确认已经启动过最新工程，或已经执行过数据库升级脚本。
SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qiming_bbs;
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM bbs_replies WHERE thread_id IN (SELECT id FROM bbs_threads WHERE title LIKE '【D%');
DELETE FROM bbs_thread_contents WHERE thread_id IN (SELECT id FROM bbs_threads WHERE title LIKE '【D%');
DELETE FROM bbs_threads WHERE title LIKE '【D%';
SET FOREIGN_KEY_CHECKS=1;

-- 1. 插入/更新元老用户
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('beiwei', 'beiwei', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '北炜', 'LG-BEIWEI', 'TG-LG-001', NULL, NULL, 'D日负责前导侦察与博铺港登陆警戒。习惯先看地形，再开会。', '执委会 / 前导侦察组', '前导侦察、登陆警戒、战术判断', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'EXECUTIVE', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('yanquezhi', 'yanquezhi', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '燕雀志', 'LG-YANQUEZHI', 'TG-ENG-001', NULL, NULL, '负责浮动码头建设，最讨厌有人把工程钢材拿去做别的用途。', '工程组 / 一号工程', '浮动码头、钢架拼装、临时海工设施', 'STRATEGIC', '博铺港 / 一号工程', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('meiwan', 'meiwan', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '梅晚', 'LG-MEIWAN', 'TG-ENG-002', NULL, NULL, '负责博铺港、百仞滩一线建设，和监理吵架是工作的一部分。', '临高建设组 / 道路工程', '道路施工、营地建设、施工调度', 'STRATEGIC', '博铺港—百仞滩公路工段', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('zhuotianmin', 'zhuotianmin', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '卓天敏', 'LG-ZHUOTIANMIN', 'TG-QA-001', NULL, NULL, '坚持质量标准，认为临时工程也不能靠嘴硬撑住。', '工程监理组', '工程验收、道路压实、施工质量', 'STRATEGIC', '博铺港—百仞滩公路工段', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('salina', 'salina', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '萨琳娜', 'LG-SALINA', 'TG-MED-001', NULL, NULL, '负责登陆初期医疗与卫生制度。第一座厕所的坚定维护者。', '医疗卫生组', '急救、卫生隔离、营地防疫', 'STRATEGIC', '临高首都区 / 医疗点', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('ranyaoyao', 'ranyaoyao', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '冉耀', 'LG-RANYAO', 'TG-POL-001', NULL, NULL, '负责治安组外巡与身份登记。D日傍晚发现额外穿越人员。', '治安组', '营地治安、身份核验、俘虏看押', 'STRATEGIC', '临高首都区 / 治安岗', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('guoyi', 'guoyi', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '郭逸', 'LG-GUOYI', 'TG-SPEC-001', NULL, NULL, 'D日意外卷入穿越事件，经过审查后转入治安协助岗位。', '临时登记人员 / 执法观察', '基层执法、询问记录、治安协助', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('xueziliang', 'xueziliang', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '薛子良', 'LG-XUEZILIANG', 'TG-SPEC-002', NULL, NULL, 'D日意外卷入穿越事件，最早的非名单登记人员之一。', '临时登记人员 / 后勤协助', '文书、仓储记录、临时勤务', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('wude', 'wude', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '邬德', 'LG-WUDE', 'TG-ADM-001', NULL, NULL, '主持早期俘虏管理与劳工制度改革，讲究现实主义。', '执委会 / 归化管理', '俘虏分化、工分制度、基层治理', 'STRATEGIC', '临高首都区 / 政务点', 1, 'EXECUTIVE', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('maqianzhu', 'maqianzhu', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '马千瞩', 'LG-MAQIANZHU', 'TG-PLAN-001', NULL, NULL, '习惯把所有混乱事情做成表格，然后再写成文件。', '计划委员会', '劳工制度、物资统筹、文件起草', 'STRATEGIC', '临高首都区 / 计划委员会', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('wendesi', 'wendesi', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '文德嗣', 'LG-WENDESI', 'TG-PROP-001', NULL, NULL, '负责早期宣传口径与《临高快讯》，认为谣言比蚊子更难清理。', '宣传与教育组', '快讯编辑、宣传口径、归化教育', 'STRATEGIC', '临高首都区 / 宣传点', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('xiaozishan', 'xiaozishan', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '萧子山', 'LG-XIAOZISHAN', 'TG-CAN-001', NULL, NULL, '负责登瀛洲号广州行，外线工作讲究低调、谨慎和可撤退。', '航海贸易组 / 广州先遣站', '外线接触、商贸采购、广州情报', 'STRATEGIC', '广州先遣站', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('duwen', 'duwen', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '杜雯', 'LG-DUWEN', 'TG-VILL-001', NULL, NULL, '负责盐场村群众发动与基层政权摸索，常被各组临时借调。', '盐场村工作队', '群众工作、基层组织、农民讲习所', 'STRATEGIC', '盐场村 / 马袅农民讲习所', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('xiyazhou', 'xiyazhou', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '席亚洲', 'LG-XIYAZHOU', 'TG-MIL-001', NULL, NULL, '负责早期军事训练与临高角警戒，弹药账本看得比战报还紧。', '军务安保组', '伏波军训练、巡逻、防御作战', 'STRATEGIC', '临高角 / 军务警戒线', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('jituisi', 'jituisi', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '季退思', 'LG-JITUISI', 'TG-CHEM-001', NULL, NULL, '研制铵木炸药，所有实验都让治安组心惊胆战。', '化工组', '炸药、火工品、临时化工实验', 'STRATEGIC', '百仞滩 / 化工棚', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('linshenhe', 'linshenhe', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '林深河', 'LG-LINSHENHE', 'TG-IND-001', NULL, NULL, '早期工业组成员，常说锅也算一种可再分配金属资源。', '工业组', '钢铁、机修、设备拆解与复原', 'STRATEGIC', '百仞城 / 工业棚', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('zhanwuya', 'zhanwuya', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '展无涯', 'LG-ZHANWUYA', 'TG-GUN-001', NULL, NULL, '负责早期铸炮方案，坚信没有炮解决不了的海盗。', '炮械组', '铸炮、火器结构、兵工试制', 'STRATEGIC', '百仞滩 / 炮械棚', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('wangluobing', 'wangluobing', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '王洛宾', 'LG-WANGLUOBING', 'TG-SALT-001', NULL, NULL, '进入盐场村了解情况，也参与早期铸炮讨论。', '盐场村工作队 / 铸炮协作', '盐场调查、群众工作、炮械协作', 'STRATEGIC', '盐场村', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('dumen', 'dumen', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '独孤求婚', 'LG-DUGUQIUHUN', 'TG-POL-002', NULL, NULL, '东门市派出所初任所长，认为制度必须有牙齿。', '东门市派出所', '治安打非、派出所建设、基层巡逻', 'STRATEGIC', '东门市派出所', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES ('suope', 'suope', '$2y$10$fOv0EDqM/QizWRTF30Dcoey6OhloS2j4AIb0er4bja4cWhvyuMdtq', '索普', 'LG-SUOPE', 'TG-GD-001', NULL, NULL, '外线组成员，负责广东方向情报与商路观察。', '外线组 / 广东方向', '外线联络、情报转运、商路观察', 'STRATEGIC', '广东 / 外线观察点', 1, 'USER', 'ACTIVE', 0, 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), role=VALUES(role), status='ACTIVE', updated_at=NOW();

-- 2. 插入/更新分区
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('元老院公告（执委会代表发）', 'senate', '执委会公告、重大制度、战时命令与公报', 10, 'ACTIVE', 1, (SELECT id FROM bbs_users WHERE username='wude'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('议事厅', 'council-hall', '日常议案、争论、临时协调和跨部门讨论', 20, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='beiwei'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('临高首都区建设', 'lingao-capital', '博铺、百仞滩、百仞城、东门市与首都区基础建设', 30, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='meiwan'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('工业建设', 'industry', '钢铁、机械、能源、化工、修造与设备维护', 40, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='linshenhe'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('农业与物资', 'agriculture', '农庄、粮食、仓储、工分、配给与劳动力', 50, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='maqianzhu'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('医疗卫生', 'medicine', '营地卫生、防疫、急救、饮水与厕所制度', 60, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='salina'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('军务安保', 'security', '治安、伏波军、巡逻、防御与战报', 70, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='xiyazhou'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('航海贸易', 'trade', '广州行、登瀛洲号、外线商贸与情报', 80, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='xiaozishan'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('教育档案', 'education', '临高快讯、讲习所、归化教育与档案整理', 90, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='wendesi'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();
INSERT INTO bbs_categories (name, slug, description, sort_order, status, executive_only, manager_user_id, thread_count, created_at, updated_at) VALUES ('政务制度', 'governance', '基层治理、工分制度、户籍、派出所与东门市', 100, 'ACTIVE', 0, (SELECT id FROM bbs_users WHERE username='wude'), 0, '1628-09-26 00:00:00', NOW()) ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status='ACTIVE', executive_only=VALUES(executive_only), manager_user_id=VALUES(manager_user_id), updated_at=NOW();

-- 3. 插入帖子与正文
-- 【D1·执委会】圣船抵达后第一阶段生存任务通告
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D1·执委会】圣船抵达后第一阶段生存任务通告', (SELECT id FROM bbs_users WHERE username='beiwei'), (SELECT id FROM bbs_categories WHERE slug='senate'), 238, 0, 18, 1, 'PUBLISHED', '1628-09-26 02:14:00', '1628-09-26 02:14:00', '1628-09-26 02:14:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 圣船抵达后第一阶段生存任务通告

全体元老注意：

圣船已完成穿越，全员确认抵达目标时空。当前位置为琼州府临高县博铺港附近海域。

初步侦察结果显示，本地无近代化武装力量，周边以渔村、盐场与小规模明军地方武装为主。我们目前最大的敌人不是明军，而是混乱、疾病、饥饿和自以为是。

## 今日优先任务

1. 建立博铺港登陆点安全圈；
2. 修筑临时浮动码头，保证物资下船；
3. 统计人员、武器、柴油、药品、粮食；
4. 建立无线通信体系；
5. 医疗组立刻划定饮水与厕所制度；
6. 治安组负责外围巡逻与身份核验；
7. 工程组尽快提出博铺至百仞滩道路方案。

## 纪律

- 禁止单人离营；
- 禁止私自携枪外出；
- 禁止与土著私下交易；
- 禁止把现代物品带出营地展示。

穿越已经发生，我们没有退路。

从今天开始，临高就是我们的根据地。');

-- 【D1·一号工程】浮动码头施工日志与材料需求
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D1·一号工程】浮动码头施工日志与材料需求', (SELECT id FROM bbs_users WHERE username='yanquezhi'), (SELECT id FROM bbs_categories WHERE slug='industry'), 126, 0, 11, 0, 'PUBLISHED', '1628-09-26 07:33:00', '1628-09-26 07:33:00', '1628-09-26 07:33:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 一号工程：浮动码头施工日志

目前浮动码头已经开始施工。

采用方案为钢架浮桥加拼接浮筒。先满足卸货，再谈美观和寿命。

## 当前困难

- 海潮变化比预估明显；
- 焊接点需要稳定供电；
- 木材加工能力不足；
- 吊装区域人员太杂；
- 部分元老完全没有施工安全意识。

## 需求

- 钢缆优先给一号工程；
- 柴油机至少保证两台；
- 治安组派人维持施工区边界；
- 医疗组派一个急救点。

另外，再说一次：不要把工程钢材拿去做炉架、烤架、晾衣杆。');

-- 【D+1·道路】博铺—百仞滩十二公里简易公路施工计划
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D+1·道路】博铺—百仞滩十二公里简易公路施工计划', (SELECT id FROM bbs_users WHERE username='meiwan'), (SELECT id FROM bbs_categories WHERE slug='lingao-capital'), 164, 0, 14, 0, 'PUBLISHED', '1628-09-27 18:20:00', '1628-09-27 18:20:00', '1628-09-27 18:20:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 博铺—百仞滩简易公路施工计划

执委会要求尽快打通博铺港至百仞滩道路，全长约十二公里。

这不是景观大道，也不是市政样板路。它现在唯一任务就是让卡车、拖车和人员能稳定通过。

## 工程方法

- 推土机先开路；
- 低洼处碎石填坑；
- 沟渠用木桥或临时涵管；
- 关键路段安排人工排水；
- 夜间停止重车通行。

## 风险

海南雨水、泥地和蚊子都比会议纪要更真实。

监理组认为压实标准不够。我承认不够，但现在不能等到所有标准完美才修路。

没有这条路，百仞城就只能画在纸上。');

-- 【D1·卫生】第一座现代厕所投入使用及营地防疫规定
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D1·卫生】第一座现代厕所投入使用及营地防疫规定', (SELECT id FROM bbs_users WHERE username='salina'), (SELECT id FROM bbs_categories WHERE slug='medicine'), 202, 0, 23, 1, 'PUBLISHED', '1628-09-26 16:45:00', '1628-09-26 16:45:00', '1628-09-26 16:45:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 第一座现代厕所投入使用

今天，新世界第一座现代厕所正式完工。

虽然只是临时结构，但它很可能比今天任何一场会议都重要。我们现在最怕的不是几百乡勇，而是肠道病、污染水源和集体腹泻。

## 立即执行

1. 所有人必须使用指定厕所；
2. 饮水必须煮沸；
3. 厨房和厕所必须分区；
4. 伤口必须登记处理；
5. 垃圾坑每日覆盖；
6. 不得把卫生纸挪作引火物。

医疗组已经发现多例擦伤、脚伤和轻度中暑。工程组再不戴安全帽，我会要求治安组协助执行。');

-- 【D1·治安】关于发现额外穿越人员的情况通报
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D1·治安】关于发现额外穿越人员的情况通报', (SELECT id FROM bbs_users WHERE username='ranyaoyao'), (SELECT id FROM bbs_categories WHERE slug='security'), 188, 0, 9, 0, 'PUBLISHED', '1628-09-26 20:03:00', '1628-09-26 20:03:00', '1628-09-26 20:03:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 关于发现额外穿越人员的情况通报

今日傍晚，治安组外围巡逻发现三名身份异常人员，经初步核验为本次穿越事件卷入人员：

- 郭逸；
- 薛子良；
- 萨琳娜。

其中萨琳娜已转入医疗卫生组协助工作。其余人员完成隔离询问后，暂按临时登记元老处理。

## 处置意见

- 补录身份档案；
- 暂不单独外出；
- 由治安组安排临时岗位；
- 后续交执委会确认待遇。

另外，土著已经注意到我们在博铺港的活动。夜间灯光外泄问题必须控制。');

-- 【D+17·政务】俘虏管理与初步工分制度意见
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D+17·政务】俘虏管理与初步工分制度意见', (SELECT id FROM bbs_users WHERE username='wude'), (SELECT id FROM bbs_categories WHERE slug='governance'), 211, 0, 16, 0, 'PUBLISHED', '1628-10-13 22:10:00', '1628-10-13 22:10:00', '1628-10-13 22:10:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 俘虏管理与初步工分制度意见

第一次反围剿后，治安组已经完成主要俘虏审讯。

我们现在不是在玩文明游戏。几百张嘴每天都要吃饭，吃完饭还会逃、会闹、会传播谣言。必须建立清楚的劳动和配给关系。

## 基本原则

- 普通乡勇按劳改编组；
- 地痞、惯匪重点看押；
- 黎人俘虏单独登记，避免简单粗暴处理；
- 未成年人与妇女不得虐待；
- 劳动表现和口粮、住宿、工具优先级挂钩。

## 工分

第一阶段工分不追求完美，只要能让人明白：

干活才有饭吃，守规矩才能活得更好。

后续请计划委员会拿出更细表格。');

-- 【D+18·宣传】《临高快讯》创刊说明
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D+18·宣传】《临高快讯》创刊说明', (SELECT id FROM bbs_users WHERE username='wendesi'), (SELECT id FROM bbs_categories WHERE slug='education'), 96, 0, 7, 0, 'PUBLISHED', '1628-10-14 09:00:00', '1628-10-14 09:00:00', '1628-10-14 09:00:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 《临高快讯》创刊说明

从今天开始，《临高快讯》正式发行。

主要刊登：

- 执委会通知；
- 战报摘要；
- 工程进度；
- 俘虏审讯纪要节选；
- 卫生与治安提醒；
- 物资缺口。

它不是文艺刊物，也不是谁的情绪出口。

目前营地谣言已经开始滋生，有人说临高土著会妖术，有人说圣船还能再启动一次，还有人说执委会藏了咖啡。

都不属实。

信息必须统一出口。否则明军还没来，我们自己先乱。');

-- 【D+36·外线】登瀛洲号广州行前会议纪要
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D+36·外线】登瀛洲号广州行前会议纪要', (SELECT id FROM bbs_users WHERE username='xiaozishan'), (SELECT id FROM bbs_categories WHERE slug='trade'), 174, 0, 12, 0, 'PUBLISHED', '1628-11-01 06:40:00', '1628-11-01 06:40:00', '1628-11-01 06:40:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 登瀛洲号广州行前会议纪要

三等运输舰“登瀛洲”号即将从博铺启程前往广州。

## 目标

1. 建立广州先遣站；
2. 接触可靠商人；
3. 采购铁料、药材、粮食、布匹；
4. 观察广东官府反应；
5. 为后续外线情报网络打基础。

## 统一口径

对外称澳洲海商。

不得谈穿越、不得谈元老院、不得展示现代物品。

无线电设备由专人保管。

另外请工业组不要再在会后追问能不能买一船铁。我们不是去逛五金市场。');

-- 【D+43·盐场村】群众工作与马袅农民讲习所设想
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D+43·盐场村】群众工作与马袅农民讲习所设想', (SELECT id FROM bbs_users WHERE username='duwen'), (SELECT id FROM bbs_categories WHERE slug='agriculture'), 149, 0, 10, 0, 'PUBLISHED', '1628-11-08 18:30:00', '1628-11-08 18:30:00', '1628-11-08 18:30:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 盐场村工作队记录

席亚洲和我今天开始在盐场村摸索群众工作。

村民最关心的不是制度设计，而是：

- 明天有没有饭；
- 欠债会不会被追；
- 我们是不是又一拨海匪；
- 给我们干活能不能拿到实物。

## 初步办法

1. 建立马袅农民讲习所；
2. 用最简单的话解释工分；
3. 先解决盐、粮、药和工具；
4. 不急着讲大道理；
5. 选可靠土著做小组长。

基层政权不是贴一张告示就能建立的。

它得从一碗粥、一把锄头、一场病能不能治开始。');

-- 【D+47·化工】铵木炸药试制成功与安全距离建议
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D+47·化工】铵木炸药试制成功与安全距离建议', (SELECT id FROM bbs_users WHERE username='jituisi'), (SELECT id FROM bbs_categories WHERE slug='industry'), 132, 0, 8, 0, 'PUBLISHED', '1628-11-12 21:12:00', '1628-11-12 21:12:00', '1628-11-12 21:12:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 铵木炸药试制记录

今日完成铵木炸药小批量试制。

效果可以接受，但稳定性仍需观察。

## 注意事项

- 试验地点必须远离营房、仓库和厕所；
- 不允许非化工组人员围观；
- 雷管与炸药分库存放；
- 每次领用必须有治安组签字。

这东西不是烟花，更不是用来证明谁胆子大的玩具。

如果军务组需要，请先给出用途和数量。');

-- 【D+71·战报】第一次临高角海战简报
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D+71·战报】第一次临高角海战简报', (SELECT id FROM bbs_users WHERE username='xiyazhou'), (SELECT id FROM bbs_categories WHERE slug='security'), 260, 0, 31, 1, 'PUBLISHED', '1628-12-06 23:20:00', '1628-12-06 23:20:00', '1628-12-06 23:20:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 第一次临高角海战简报

今日凌晨，临高角海域发现疑似海盗伪装接近。

对方试图利用夜色靠近观察，被我方发现并警告无效后交火。

## 战果

- 击沉海盗船两艘；
- 俘虏十八人；
- 缴获双桅快船一艘；
- 我方无阵亡。

## 问题

现代火力对十七世纪海盗有压倒性优势，但弹药消耗速度比预估高。

如果不能建立自主弹药、火炮与船只维修体系，今天的胜利只能算库存燃烧。

请工业组、炮械组、化工组参加明日联席会议。');

-- 【D+80·工业】炼钢、船坞与伏波号改建需求清单
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('【D+80·工业】炼钢、船坞与伏波号改建需求清单', (SELECT id FROM bbs_users WHERE username='linshenhe'), (SELECT id FROM bbs_categories WHERE slug='industry'), 142, 0, 11, 0, 'PUBLISHED', '1628-12-15 19:05:00', '1628-12-15 19:05:00', '1628-12-15 19:05:00');
SET @thread_id = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@thread_id, '# 炼钢、船坞与伏波号改建需求清单

简易船坞开始搭建。缴获海盗双桅快船将进行改建维护，暂命名为“伏波号”。

同时炼钢试验与铸炮准备也在推进。

## 当前缺口

- 合格耐火材料；
- 稳定木炭供应；
- 熟练钳工；
- 可用铁料；
- 干燥仓库；
- 不会把工具借走不还的人。

工业化不是口号。

它首先表现为每一把锤子都有人登记。');

-- 4. 插入评论与楼中回复
-- 评论：【D1·执委会】圣船抵达后第一阶段生存任务通告
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D1·执委会】圣船抵达后第一阶段生存任务通告' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='meiwan'), NULL, 1, '工程组申请柴油、推土机和钢材优先权。不卸货，后面所有计划都是纸。', 2, 'PUBLISHED', '1628-09-26 02:31:00', '1628-09-26 02:31:00');
SET @parent_p1_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 2, '医疗组要求在码头和营地之间设隔离点。谁受伤不登记，后果自负。', 4, 'PUBLISHED', '1628-09-26 02:48:00', '1628-09-26 02:48:00');
SET @parent_p1_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, '同意先建安全圈。纪律要写清楚，不然今晚就会有人出去看热闹。', 3, 'PUBLISHED', '1628-09-26 03:05:00', '1628-09-26 03:05:00');
SET @parent_p1_3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='duwen'), @parent_p1_1, 0, '工程组先别把所有人抢走，厨房和卫生组也需要人。', 1, 'PUBLISHED', '1628-09-26 03:15:00', '1628-09-26 03:15:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='beiwei'), @parent_p1_3, 0, '治安组今晚开始设三道口令。答不上来的先扣下。', 2, 'PUBLISHED', '1628-09-26 03:20:00', '1628-09-26 03:20:00');

-- 评论：【D1·一号工程】浮动码头施工日志与材料需求
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D1·一号工程】浮动码头施工日志与材料需求' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='linshenhe'), NULL, 1, '钢缆库存还能撑几天，但焊条别乱领。有人拿焊条去烤鱼，已记名。', 5, 'PUBLISHED', '1628-09-26 08:00:00', '1628-09-26 08:00:00');
SET @parent_p2_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='jituisi'), NULL, 2, '发电别全给焊机，化工棚也需要稳定电源。', 1, 'PUBLISHED', '1628-09-26 08:20:00', '1628-09-26 08:20:00');
SET @parent_p2_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 3, '施工区今天已经三例割伤。安全帽、安全鞋、手套，不是现代文明装饰品。', 3, 'PUBLISHED', '1628-09-26 09:02:00', '1628-09-26 09:02:00');
SET @parent_p2_3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='yanquezhi'), @parent_p2_1, 0, '烤鱼事件确认属实，涉事人员已经被我派去搬浮筒。', 2, 'PUBLISHED', '1628-09-26 09:30:00', '1628-09-26 09:30:00');

-- 评论：【D+1·道路】博铺—百仞滩十二公里简易公路施工计划
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D+1·道路】博铺—百仞滩十二公里简易公路施工计划' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='zhuotianmin'), NULL, 1, '压实标准不能因为是临时路就全部放弃。重车一过，坏的还是工程组。', 4, 'PUBLISHED', '1628-09-27 19:00:00', '1628-09-27 19:00:00');
SET @parent_p3_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='meiwan'), @parent_p3_1, 0, '三天后坏可以修，今天没路大家就靠肩膀背物资。', 6, 'PUBLISHED', '1628-09-27 19:08:00', '1628-09-27 19:08:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='maqianzhu'), NULL, 2, '请工程组给出每日用工人数。计划委员会要做工分核算。', 2, 'PUBLISHED', '1628-09-27 19:40:00', '1628-09-27 19:40:00');
SET @parent_p3_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='beiwei'), NULL, 3, '道路两侧必须有警戒。今天一辆叉车差点翻到沟里。', 3, 'PUBLISHED', '1628-09-27 20:12:00', '1628-09-27 20:12:00');
SET @parent_p3_3 = LAST_INSERT_ID();

-- 评论：【D1·卫生】第一座现代厕所投入使用及营地防疫规定
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D1·卫生】第一座现代厕所投入使用及营地防疫规定' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='jituisi'), NULL, 1, '卫生纸库存确实不多，但我不敢反对医疗组。', 6, 'PUBLISHED', '1628-09-26 17:01:00', '1628-09-26 17:01:00');
SET @parent_p4_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='salina'), @parent_p4_1, 0, '你可以反对，然后负责明天所有腹泻病人。', 12, 'PUBLISHED', '1628-09-26 17:04:00', '1628-09-26 17:04:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='dumen'), NULL, 2, '治安组已抓到偷卫生纸点火的人。炊事班的，已罚洗厕所。', 9, 'PUBLISHED', '1628-09-26 17:30:00', '1628-09-26 17:30:00');
SET @parent_p4_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wendesi'), NULL, 3, '建议《临高快讯》第一期重点宣传厕所制度。这个比口号有用。', 2, 'PUBLISHED', '1628-09-26 18:10:00', '1628-09-26 18:10:00');
SET @parent_p4_3 = LAST_INSERT_ID();

-- 评论：【D1·治安】关于发现额外穿越人员的情况通报
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D1·治安】关于发现额外穿越人员的情况通报' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='guoyi'), NULL, 1, '我再说明一次，我真不是海盗。你们拿枪指着我时，我也很害怕。', 10, 'PUBLISHED', '1628-09-26 20:22:00', '1628-09-26 20:22:00');
SET @parent_p5_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='ranyaoyao'), @parent_p5_1, 0, '你从树后面突然冲出来，任何治安人员都会先举枪。', 7, 'PUBLISHED', '1628-09-26 20:25:00', '1628-09-26 20:25:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='xueziliang'), NULL, 2, '而且你们一群人穿迷彩服，我当时以为进了什么演习现场。', 5, 'PUBLISHED', '1628-09-26 20:40:00', '1628-09-26 20:40:00');
SET @parent_p5_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 3, '既然已经登记，医疗组需要人手。伤员比文件多。', 4, 'PUBLISHED', '1628-09-26 21:00:00', '1628-09-26 21:00:00');
SET @parent_p5_3 = LAST_INSERT_ID();

-- 评论：【D+17·政务】俘虏管理与初步工分制度意见
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D+17·政务】俘虏管理与初步工分制度意见' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='maqianzhu'), NULL, 1, '建议从明天开始统一劳工档案。姓名、来源、身体状况、技能、工分都要登记。', 5, 'PUBLISHED', '1628-10-13 22:30:00', '1628-10-13 22:30:00');
SET @parent_p6_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='duwen'), NULL, 2, '已经有俘虏主动问干什么活能多拿粥。说明规则正在起作用。', 3, 'PUBLISHED', '1628-10-13 22:51:00', '1628-10-13 22:51:00');
SET @parent_p6_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wude'), @parent_p6_2, 0, '不是规则起作用，是他们发现不干活真的没饭吃。', 8, 'PUBLISHED', '1628-10-13 23:00:00', '1628-10-13 23:00:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 3, '俘虏分组前必须体检。传染病先隔离，不然劳动力会变成病源。', 4, 'PUBLISHED', '1628-10-13 23:12:00', '1628-10-13 23:12:00');
SET @parent_p6_3 = LAST_INSERT_ID();

-- 评论：【D+18·宣传】《临高快讯》创刊说明
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D+18·宣传】《临高快讯》创刊说明' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='beiwei'), NULL, 1, '建议每日发行。各组至少报一次真实进度，别只报喜。', 4, 'PUBLISHED', '1628-10-14 09:22:00', '1628-10-14 09:22:00');
SET @parent_p7_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='maqianzhu'), NULL, 2, '宣传也是生产力。尤其是大家都睡不够的时候。', 3, 'PUBLISHED', '1628-10-14 09:40:00', '1628-10-14 09:40:00');
SET @parent_p7_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wendesi'), @parent_p7_2, 0, '你这句话我准备印在第二期角落里。', 2, 'PUBLISHED', '1628-10-14 09:51:00', '1628-10-14 09:51:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='dumen'), NULL, 3, '请加一条：不要散布圣船还能回去的谣言。已经影响治安。', 5, 'PUBLISHED', '1628-10-14 10:05:00', '1628-10-14 10:05:00');
SET @parent_p7_3 = LAST_INSERT_ID();

-- 评论：【D+36·外线】登瀛洲号广州行前会议纪要
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D+36·外线】登瀛洲号广州行前会议纪要' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='linshenhe'), NULL, 1, '能不能顺便采购铁料？哪怕一船废铁也行。', 6, 'PUBLISHED', '1628-11-01 07:10:00', '1628-11-01 07:10:00');
SET @parent_p8_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='xiaozishan'), @parent_p8_1, 0, '我们是去建立先遣站，不是去把广州五金市场搬空。', 8, 'PUBLISHED', '1628-11-01 07:18:00', '1628-11-01 07:18:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='suope'), NULL, 2, '建议广州点保留长期安全屋。外线情报不能每次靠船现跑。', 5, 'PUBLISHED', '1628-11-01 07:50:00', '1628-11-01 07:50:00');
SET @parent_p8_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 3, '外线人员必须统一口径。谁把元老院说漏嘴，回来先写检讨。', 4, 'PUBLISHED', '1628-11-01 08:11:00', '1628-11-01 08:11:00');
SET @parent_p8_3 = LAST_INSERT_ID();

-- 评论：【D+43·盐场村】群众工作与马袅农民讲习所设想
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D+43·盐场村】群众工作与马袅农民讲习所设想' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wangluobing'), NULL, 1, '盐场村的债务关系比我们想的复杂，不能直接宣布清零。', 4, 'PUBLISHED', '1628-11-08 19:00:00', '1628-11-08 19:00:00');
SET @parent_p9_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='duwen'), @parent_p9_1, 0, '是的，先找能说话的人，再找能干活的人，最后才谈制度。', 3, 'PUBLISHED', '1628-11-08 19:08:00', '1628-11-08 19:08:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='maqianzhu'), NULL, 2, '工分券可以先小范围试行，别一次铺太大。', 2, 'PUBLISHED', '1628-11-08 19:40:00', '1628-11-08 19:40:00');
SET @parent_p9_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wendesi'), NULL, 3, '讲习所需要识字材料。我可以先做一版最简课本。', 4, 'PUBLISHED', '1628-11-08 20:12:00', '1628-11-08 20:12:00');
SET @parent_p9_3 = LAST_INSERT_ID();

-- 评论：【D+47·化工】铵木炸药试制成功与安全距离建议
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D+47·化工】铵木炸药试制成功与安全距离建议' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='xiyazhou'), NULL, 1, '军务组需要少量试用，但必须有安全操作手册。', 3, 'PUBLISHED', '1628-11-12 21:40:00', '1628-11-12 21:40:00');
SET @parent_p10_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='jituisi'), @parent_p10_1, 0, '手册可以写，问题是你们的人会不会照做。', 5, 'PUBLISHED', '1628-11-12 21:45:00', '1628-11-12 21:45:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='salina'), NULL, 2, '试验地点离医疗点远一点。上次爆声把两个病人吓醒了。', 4, 'PUBLISHED', '1628-11-12 22:03:00', '1628-11-12 22:03:00');
SET @parent_p10_2 = LAST_INSERT_ID();

-- 评论：【D+71·战报】第一次临高角海战简报
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D+71·战报】第一次临高角海战简报' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='zhanwuya'), NULL, 1, '炮械组已经开始整理铸炮方案。别催，炉子还不稳定。', 7, 'PUBLISHED', '1628-12-06 23:40:00', '1628-12-06 23:40:00');
SET @parent_p11_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='jituisi'), NULL, 2, '火药和炸药都能协助，但储存条件必须先解决。', 3, 'PUBLISHED', '1628-12-06 23:55:00', '1628-12-06 23:55:00');
SET @parent_p11_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='linshenhe'), NULL, 3, '工业组缺铁、缺人、缺睡眠。会议可以开，但别只开会。', 6, 'PUBLISHED', '1628-12-07 00:20:00', '1628-12-07 00:20:00');
SET @parent_p11_3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='xiyazhou'), @parent_p11_3, 0, '明天会议只谈清单，不谈愿景。', 4, 'PUBLISHED', '1628-12-07 00:30:00', '1628-12-07 00:30:00');
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='beiwei'), NULL, 4, '海盗俘虏单独审讯，看看有没有后续船队消息。', 2, 'PUBLISHED', '1628-12-07 01:05:00', '1628-12-07 01:05:00');
SET @parent_p11_4 = LAST_INSERT_ID();

-- 评论：【D+80·工业】炼钢、船坞与伏波号改建需求清单
SET @thread_id = (SELECT id FROM bbs_threads WHERE title='【D+80·工业】炼钢、船坞与伏波号改建需求清单' ORDER BY id DESC LIMIT 1);
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wude'), NULL, 1, '工具登记制度同意。现在丢一把钳子，比少一份会议纪要严重。', 5, 'PUBLISHED', '1628-12-15 19:30:00', '1628-12-15 19:30:00');
SET @parent_p12_1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='zhanwuya'), NULL, 2, '炮械组需要优先获得耐火材料，否则铸炮只能停在图纸上。', 4, 'PUBLISHED', '1628-12-15 20:01:00', '1628-12-15 20:01:00');
SET @parent_p12_2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='wangluobing'), NULL, 3, '盐场那边可以组织人烧木炭，但要给明确工分。', 3, 'PUBLISHED', '1628-12-15 20:30:00', '1628-12-15 20:30:00');
SET @parent_p12_3 = LAST_INSERT_ID();
INSERT INTO bbs_replies (thread_id, author_id, parent_id, floor_no, content, like_count, status, created_at, updated_at) VALUES (@thread_id, (SELECT id FROM bbs_users WHERE username='maqianzhu'), @parent_p12_3, 0, '给我人数和日产量预估，我明天做表。', 2, 'PUBLISHED', '1628-12-15 20:40:00', '1628-12-15 20:40:00');

-- 5. 回填计数
UPDATE bbs_threads t SET comment_count = (SELECT COUNT(*) FROM bbs_replies r WHERE r.thread_id = t.id AND r.status='PUBLISHED'), last_replied_at = COALESCE((SELECT MAX(r.created_at) FROM bbs_replies r WHERE r.thread_id = t.id), t.last_replied_at) WHERE t.title LIKE '【D%';
UPDATE bbs_categories c SET thread_count = (SELECT COUNT(*) FROM bbs_threads t WHERE t.category_id = c.id AND t.status='PUBLISHED');
UPDATE bbs_users u SET post_count = (SELECT COUNT(*) FROM bbs_threads t WHERE t.author_id = u.id AND t.status='PUBLISHED'), reply_count = (SELECT COUNT(*) FROM bbs_replies r WHERE r.author_id = u.id AND r.status='PUBLISHED') WHERE u.username IN ('beiwei','yanquezhi','meiwan','zhuotianmin','salina','ranyaoyao','guoyi','xueziliang','wude','maqianzhu','wendesi','xiaozishan','duwen','xiyazhou','jituisi','linshenhe','zhanwuya','wangluobing','dumen','suope');

SELECT '启明元老院 D日演示数据库已插入完成。演示用户默认密码：123456' AS message;