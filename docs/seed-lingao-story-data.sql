-- 启明元老院 BBS：小说化演示用户、帖子与评论种子数据
-- 用法：mysql --default-character-set=utf8mb4 -uroot -proot
--      SOURCE D:/github/modern-bbs/docs/seed-lingao-story-data.sql;
-- 说明：本脚本只会刷新下方这批演示标题，不会清空你的真实用户和其它帖子。
CREATE DATABASE IF NOT EXISTS qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qiming_bbs;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 1;

SET @seed_password_hash = '$2y$10$2vIQAb0TTt4lSc9zoY4RY.Zz4.eCkRqmK4FTnj57S3GlL0wFSTOuW'; -- 演示用户默认密码：123456

-- 1. 角色和分区基础数据
INSERT INTO bbs_roles (id, code, name, description) VALUES
(1, 'USER', '普通元老', '登记入岛的普通元老账号，可发帖、回复和参与讨论'),
(2, 'ADMIN', '执委会管理员', '拥有后台管理权限'),
(3, 'EXECUTIVE', '执委会代表', '可以在元老院公告、执委会公报等正式分区发帖'),
(4, 'MODERATOR', '分区执事', '可管理指定分区内容')
ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description);

INSERT INTO bbs_categories (id, parent_id, name, slug, description, sort_order, status, executive_only) VALUES
(1, NULL, '元老院公告', 'senate', '正式规则、公共通知、重要决议和执委会公告，仅执委会代表可发布', 10, 'ACTIVE', b'1'),
(9, NULL, '临高首都区建设', 'lingao-capital', '临高登陆点、百仞城、博铺港、首都区规划与城市治理', 15, 'ACTIVE', b'0'),
(2, NULL, '工业建设', 'industry', '机械、冶金、化工、电力、制造与基础设施方案', 20, 'ACTIVE', b'0'),
(3, NULL, '农业与物资', 'agriculture', '粮食、种植、畜牧、仓储、后勤和物资调配', 30, 'ACTIVE', b'0'),
(4, NULL, '医疗卫生', 'medicine', '疾病防治、药品、公共卫生、急救和检疫事务', 40, 'ACTIVE', b'0'),
(5, NULL, '军务安保', 'security', '营地防卫、武器训练、治安巡逻和风险预案', 50, 'ACTIVE', b'0'),
(6, NULL, '航海贸易', 'navigation', '港口、船只、航线、贸易和外部接触记录', 60, 'ACTIVE', b'0'),
(7, NULL, '教育档案', 'education', '识字、技术培训、教材编写和人才培养', 70, 'ACTIVE', b'0'),
(8, NULL, '政务制度', 'governance', '行政组织、法律制度、财政税务和社会治理', 80, 'ACTIVE', b'0')
ON DUPLICATE KEY UPDATE parent_id=VALUES(parent_id), name=VALUES(name), description=VALUES(description), sort_order=VALUES(sort_order), status=VALUES(status), executive_only=VALUES(executive_only);

-- 2. 演示元老用户。默认密码均为 123456。
INSERT INTO bbs_users (username, normalized_username, password_hash, nickname, call_sign, telegram_code, email, avatar_url, bio, council_department, specialty, station_scope, station_name, station_elder_count, role, status, post_count, reply_count, created_at, updated_at) VALUES
('hejingyuan', 'hejingyuan', @seed_password_hash, '何敬原', 'LG-HEJINGYUAN', 'TG-SEN-001', NULL, NULL, '负责把会议结论转成可执行条目，习惯把争论压缩成三行摘要。', '执委会秘书处', '会议纪要、政令归档、跨部门协调', 'STRATEGIC', '百仞城政务区', 1, 'EXECUTIVE', 'ACTIVE', 0, 0, NOW(), NOW()),
('linshaozhou', 'linshaozhou', @seed_password_hash, '林绍周', 'LG-LINSHAOZHOU', 'TG-IND-011', NULL, NULL, '工坊里最怕“差不多”，每个螺栓都要有来源和去向。', '工业委员会', '机械维修、蒸汽动力、工坊排产', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('maqiuzhi', 'maqiuzhi', @seed_password_hash, '马秋植', 'LG-MAQIUZHI', 'TG-AGR-006', NULL, NULL, '相信临高的秩序首先来自饭锅、仓库和晒场。', '农业与物资组', '粮食统筹、仓储防霉、种苗调拨', 'STRATEGIC', '海南主基地', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('tangyu', 'tangyu', @seed_password_hash, '唐渝', 'LG-TANGYU', 'TG-MED-003', NULL, NULL, '每天提醒大家：烧开水，比争论医学流派重要。', '医疗卫生组', '检疫、疟疾防治、饮水卫生', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('zhaomingwei', 'zhaomingwei', @seed_password_hash, '赵明卫', 'LG-ZHAOMINGWEI', 'TG-SEC-009', NULL, NULL, '负责让博铺港的夜晚安静，而不是让所有人都睡不着。', '军务安保组', '港口警戒、巡逻排班、火器训练', 'STRATEGIC', '博铺港', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('guye', 'guye', @seed_password_hash, '顾野', 'LG-GUYE', 'TG-NAV-008', NULL, NULL, '总是先问风向，再问价格。', '航海贸易组', '航线、货单、电报中继', 'STRATEGIC', '博铺港', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('wenqing', 'wenqing', @seed_password_hash, '文清', 'LG-WENQING', 'TG-EDU-002', NULL, NULL, '相信一本写得明白的教材能抵半个工坊。', '教育档案组', '识字班、技术教材、学徒考核', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('xuhe', 'xuhe', @seed_password_hash, '许鹤', 'LG-XUHE', 'TG-GOV-004', NULL, NULL, '喜欢表格，也知道表格背后是人。', '政务制度组', '户籍册、工分券、治安登记', 'STRATEGIC', '百仞城政务区', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('duwen', 'duwen', @seed_password_hash, '杜文', 'LG-DUWEN', 'TG-COM-001', NULL, NULL, '在临高能用手机内网，出临高就老老实实拍电报。', '通信与测绘组', '单片机内网、电报、地图标绘', 'STRATEGIC', '临高首都区 / 登陆点', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('liangyue', 'liangyue', @seed_password_hash, '梁越', 'LG-LIANGYUE', 'TG-GD-017', NULL, NULL, '外驻广东，能发回来的不是朋友圈，是电报。', '外线联络组', '广东采购、盐硝、铜铁渠道', 'STRATEGIC', '广东工业转运区', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('shenhaitong', 'shenhaitong', @seed_password_hash, '沈海桐', 'LG-SHENHAITONG', 'TG-TW-012', NULL, NULL, '长期外驻，记录季风、港口和人心。', '外线联络组', '台湾观察、海贸情报、病虫害记录', 'STRATEGIC', '台湾观察与技术联络点', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('songyian', 'songyian', @seed_password_hash, '宋一安', 'LG-SONGYIAN', 'TG-JP-005', NULL, NULL, '电报字数有限，所以每个词都要有价值。', '远洋观察组', '日本观察、翻译、金属器物样本', 'WORLD', 'Japan', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('hanseojun', 'hanseojun', @seed_password_hash, '韩序俊', 'LG-HANSEOJUN', 'TG-JJ-003', NULL, NULL, '济州岛风大，电报纸也要压住。', '远洋联络组', '济州岛补给、气象记录、船只联络', 'WORLD', 'South Korea', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW()),
('nguyentran', 'nguyentran', @seed_password_hash, '阮成安', 'LG-NGUYEN', 'TG-VN-006', NULL, NULL, '越南外线，最关心米价、木材和船期。', '越南联络点', '稻米、木材、港口行情', 'WORLD', 'Vietnam', 1, 'USER', 'ACTIVE', 0, 0, NOW(), NOW())
ON DUPLICATE KEY UPDATE nickname=VALUES(nickname), call_sign=VALUES(call_sign), telegram_code=VALUES(telegram_code), email=NULL, avatar_url=COALESCE(bbs_users.avatar_url, VALUES(avatar_url)), bio=VALUES(bio), council_department=VALUES(council_department), specialty=VALUES(specialty), station_scope=VALUES(station_scope), station_name=VALUES(station_name), station_elder_count=VALUES(station_elder_count), role=VALUES(role), status='ACTIVE', updated_at=NOW();

SET @u_hejingyuan = (SELECT id FROM bbs_users WHERE username='hejingyuan');
SET @u_linshaozhou = (SELECT id FROM bbs_users WHERE username='linshaozhou');
SET @u_maqiuzhi = (SELECT id FROM bbs_users WHERE username='maqiuzhi');
SET @u_tangyu = (SELECT id FROM bbs_users WHERE username='tangyu');
SET @u_zhaomingwei = (SELECT id FROM bbs_users WHERE username='zhaomingwei');
SET @u_guye = (SELECT id FROM bbs_users WHERE username='guye');
SET @u_wenqing = (SELECT id FROM bbs_users WHERE username='wenqing');
SET @u_xuhe = (SELECT id FROM bbs_users WHERE username='xuhe');
SET @u_duwen = (SELECT id FROM bbs_users WHERE username='duwen');
SET @u_liangyue = (SELECT id FROM bbs_users WHERE username='liangyue');
SET @u_shenhaitong = (SELECT id FROM bbs_users WHERE username='shenhaitong');
SET @u_songyian = (SELECT id FROM bbs_users WHERE username='songyian');
SET @u_hanseojun = (SELECT id FROM bbs_users WHERE username='hanseojun');
SET @u_nguyentran = (SELECT id FROM bbs_users WHERE username='nguyentran');

UPDATE bbs_categories SET manager_user_id=@u_hejingyuan WHERE slug='senate';
UPDATE bbs_categories SET manager_user_id=@u_xuhe WHERE slug='lingao-capital';
UPDATE bbs_categories SET manager_user_id=@u_linshaozhou WHERE slug='industry';
UPDATE bbs_categories SET manager_user_id=@u_maqiuzhi WHERE slug='agriculture';
UPDATE bbs_categories SET manager_user_id=@u_tangyu WHERE slug='medicine';
UPDATE bbs_categories SET manager_user_id=@u_zhaomingwei WHERE slug='security';
UPDATE bbs_categories SET manager_user_id=@u_guye WHERE slug='navigation';
UPDATE bbs_categories SET manager_user_id=@u_wenqing WHERE slug='education';
UPDATE bbs_categories SET manager_user_id=@u_xuhe WHERE slug='governance';

-- 3. 刷新演示帖子。重复执行会先删除同标题演示帖，再重新插入。
DELETE FROM bbs_threads WHERE title IN (
'关于临高首都区一期扩建与工时调配的临时通告',
'百仞城排水沟与营房木料优先级讨论',
'小型蒸汽机样机一号炉压测试记录',
'甘薯、稻种与仓储防霉三日调拨表',
'疟疾防控与饮水煮沸制度执行细则',
'博铺港夜间巡逻与火器训练安排',
'广州外线采购与电报中继节点建议',
'第一期识字班与工匠速成课教材目录',
'临高户籍册、工分券与治安登记试行办法'
);

SET @cat_senate = (SELECT id FROM bbs_categories WHERE slug='senate');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('关于临高首都区一期扩建与工时调配的临时通告', @u_hejingyuan, @cat_senate, 386, 0, 42, b'1', 'PUBLISHED', '1638-05-07 08:20:00', '1638-05-07 08:20:00', '1638-05-07 08:20:00');
SET @p_senate_work = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_senate_work, '# 关于临高首都区一期扩建与工时调配的临时通告

经执委会临时会议讨论，临高登陆点、百仞城与博铺港三处工程进入并行阶段。为了避免各组争抢人手、木料、石灰和车马，现将本周优先级暂定如下：

| 优先级 | 事项 | 负责组 | 说明 |
|---|---|---|---|
| 一 | 饮水井与排水沟 | 医疗卫生组 / 首都区建设 | 雨季前必须完成主沟清淤 |
| 二 | 粮仓垫高与防霉 | 农业与物资组 | 先做临高主仓，再做博铺港副仓 |
| 三 | 工坊夜间照明 | 工业委员会 | 只保留关键工段，不扩大耗油 |
| 四 | 港口巡逻哨棚 | 军务安保组 | 与博铺港装卸区同步施工 |

请各部门在回复区提交：

- 所需人手数量；
- 缺口物资；
- 可能拖延的风险；
- 可让出的资源。

本帖作为本周协调依据，各组不得再以口头约定为准。') ON DUPLICATE KEY UPDATE content=VALUES(content);

SET @cat_lingao_capital = (SELECT id FROM bbs_categories WHERE slug='lingao-capital');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('百仞城排水沟与营房木料优先级讨论', @u_xuhe, @cat_lingao_capital, 241, 0, 21, b'0', 'PUBLISHED', '1638-05-07 09:40:00', '1638-05-07 09:40:00', '1638-05-07 09:40:00');
SET @p_capital_drainage = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_capital_drainage, '# 百仞城排水沟与营房木料优先级讨论

首都区建设组今日复查了三处积水点：东侧低洼地、临时粮仓后沟、学徒营房北侧。问题不是没有人干，而是每个小组都认为自己的工程“最急”。

我的建议是先排水，再营房，再美化。理由很简单：

1. 排水沟不做，雨季一来，粮仓和营房都会受影响；
2. 木料供应已经被港口哨棚和工坊支架占用，不能同时铺开；
3. 临高现在不是现代城市规划展览，先保命、保粮、保秩序。

请工坊、农业组和军务组确认：本周能否各让出两名熟手，集中三天把主沟挖通。') ON DUPLICATE KEY UPDATE content=VALUES(content);

SET @cat_industry = (SELECT id FROM bbs_categories WHERE slug='industry');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('小型蒸汽机样机一号炉压测试记录', @u_linshaozhou, @cat_industry, 519, 0, 67, b'0', 'PUBLISHED', '1638-05-07 10:15:00', '1638-05-07 10:15:00', '1638-05-07 10:15:00');
SET @p_steam_test = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_steam_test, '# 小型蒸汽机样机一号炉压测试记录

今天上午完成一号样机第三轮炉压测试。结论先写在前面：能转，但不能交付使用。

## 记录

- 点火后第 18 分钟达到稳定压力；
- 传动轴低速运行 23 分钟，期间两次异常抖动；
- 密封处仍有轻微漏汽；
- 铁件质量不稳定，疑似同批料硬度差异过大。

## 判断

样机可以继续作为教学机和工坊训练设备，但不能直接上到粮仓碾磨或港口吊装。现在的主要矛盾不是图纸，而是材料、加工精度和熟练工数量。

## 请求

1. 农业组暂缓催要碾米动力；
2. 教育组安排 6 名学徒固定跟工坊；
3. 物资组帮忙核对铜管和耐热垫料库存。') ON DUPLICATE KEY UPDATE content=VALUES(content);

SET @cat_agriculture = (SELECT id FROM bbs_categories WHERE slug='agriculture');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('甘薯、稻种与仓储防霉三日调拨表', @u_maqiuzhi, @cat_agriculture, 298, 0, 34, b'0', 'PUBLISHED', '1638-05-07 11:05:00', '1638-05-07 11:05:00', '1638-05-07 11:05:00');
SET @p_grain_storage = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_grain_storage, '# 甘薯、稻种与仓储防霉三日调拨表

这几天粮食问题不要只看总量，重点看能不能存住、能不能按时送到。

## 三日安排

| 项目 | 地点 | 数量 | 风险 |
|---|---|---:|---|
| 甘薯 | 海南主基地 | 18 车 | 雨后腐烂加快 |
| 稻种 | 百仞城临时仓 | 6 箱 | 需要单独登记 |
| 干草 | 博铺港 | 11 捆 | 占棚位，易受潮 |
| 石灰 | 临高主仓 | 4 桶 | 防霉优先使用 |

仓库目前最大问题不是“有没有粮”，而是底层垫高不足、通风不足、出入库登记太随意。请政务制度组尽快给一个简单的仓储签收格式。') ON DUPLICATE KEY UPDATE content=VALUES(content);

SET @cat_medicine = (SELECT id FROM bbs_categories WHERE slug='medicine');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('疟疾防控与饮水煮沸制度执行细则', @u_tangyu, @cat_medicine, 337, 0, 45, b'0', 'PUBLISHED', '1638-05-07 13:30:00', '1638-05-07 13:30:00', '1638-05-07 13:30:00');
SET @p_malaria_water = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_malaria_water, '# 疟疾防控与饮水煮沸制度执行细则

医疗组今天不讨论“大方向”，只讨论能执行的三件事：水、蚊、隔离。

## 立即执行

- 饮水必须煮沸，临时营房不得直接取沟水；
- 傍晚后减少无必要外出，巡逻组领取驱蚊油；
- 发热人员登记后先观察，不得自行回工坊；
- 学徒营房每晚检查积水容器。

这不是讲究，是生产力保护。少一个熟练工，工坊进度就会慢一段；少一个医务助手，整个营地都要承担风险。') ON DUPLICATE KEY UPDATE content=VALUES(content);

SET @cat_security = (SELECT id FROM bbs_categories WHERE slug='security');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('博铺港夜间巡逻与火器训练安排', @u_zhaomingwei, @cat_security, 463, 0, 52, b'0', 'PUBLISHED', '1638-05-07 15:10:00', '1638-05-07 15:10:00', '1638-05-07 15:10:00');
SET @p_harbor_patrol = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_harbor_patrol, '# 博铺港夜间巡逻与火器训练安排

博铺港最近人货混杂，夜间有三类风险：偷盗、火源、外来探查。军务安保组建议从今晚开始执行双岗制。

## 巡逻安排

1. 港口货棚两人一组，每两个时辰换岗；
2. 火药、油料与粮仓不得安排同一人连续值守；
3. 新发火器只用于训练，不得私自带离；
4. 夜间口令每日更换，由值班记录员登记。

请航海贸易组把晚间装卸船只名单提前半天交给安保组，不要船到了才喊人开栅门。') ON DUPLICATE KEY UPDATE content=VALUES(content);

SET @cat_navigation = (SELECT id FROM bbs_categories WHERE slug='navigation');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('广州外线采购与电报中继节点建议', @u_liangyue, @cat_navigation, 401, 0, 39, b'0', 'PUBLISHED', '1638-05-07 16:25:00', '1638-05-07 16:25:00', '1638-05-07 16:25:00');
SET @p_guangdong_telegraph = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_guangdong_telegraph, '# 广州外线采购与电报中继节点建议

外驻广东这边能买到的东西不少，但问题是：越是急用的东西，越不能表现得太急。

## 采购观察

- 铜料可以分批走，不宜一次问价太大；
- 药材需要医疗组给出替代清单；
- 盐硝相关物资必须拆分采购口径；
- 船期比价格更关键，误一班船就误一旬。

## 电报建议

广州线建议设置固定三类电报模板：

1. 价格变动；
2. 船期变动；
3. 风险预警。

临高内网很方便，但外线不是手机聊天。请各组把问题压缩成能拍电报的句子。') ON DUPLICATE KEY UPDATE content=VALUES(content);

SET @cat_education = (SELECT id FROM bbs_categories WHERE slug='education');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('第一期识字班与工匠速成课教材目录', @u_wenqing, @cat_education, 222, 0, 25, b'0', 'PUBLISHED', '1638-05-07 17:00:00', '1638-05-07 17:00:00', '1638-05-07 17:00:00');
SET @p_school_textbook = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_school_textbook, '# 第一期识字班与工匠速成课教材目录

教育组先做“够用教材”，不是做百科全书。

## 拟定目录

- 数字、计量与简单账册；
- 工坊常用字：铁、铜、轴、轮、汽、压；
- 仓储常用字：入、出、存、霉、湿、封；
- 医疗卫生常用字：热、咳、泻、煮、净；
- 港口常用字：船、潮、货、票、栅。

每课不超过一页，要求能马上用在工坊、仓库、港口和医务点。请各组把最常见的 30 个词提交到回复区。') ON DUPLICATE KEY UPDATE content=VALUES(content);

SET @cat_governance = (SELECT id FROM bbs_categories WHERE slug='governance');
INSERT INTO bbs_threads (title, author_id, category_id, view_count, comment_count, like_count, pinned, status, last_replied_at, created_at, updated_at) VALUES ('临高户籍册、工分券与治安登记试行办法', @u_xuhe, @cat_governance, 358, 0, 31, b'0', 'PUBLISHED', '1638-05-07 18:20:00', '1638-05-07 18:20:00', '1638-05-07 18:20:00');
SET @p_registry_coupon = LAST_INSERT_ID();
INSERT INTO bbs_thread_contents (thread_id, content) VALUES (@p_registry_coupon, '# 临高户籍册、工分券与治安登记试行办法

政务制度组建议先建立三本册：户籍册、工分册、治安册。三本册先简单，不追求完美。

## 为什么要做

- 没有户籍册，粮食发放会靠熟脸；
- 没有工分册，劳役安排会靠吵架；
- 没有治安册，港口纠纷会反复重来。

## 试行原则

1. 每人有姓名、来源、住处、技能；
2. 工分只记可核验事项；
3. 治安登记只记事实，不写猜测；
4. 每七天汇总一次给执委会。') ON DUPLICATE KEY UPDATE content=VALUES(content);

-- 4. 演示评论与楼中回复。
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('农业组需要 12 名杂工、4 名熟悉仓储的人。粮仓垫高必须排在前面，否则雨季损耗会比搬运成本大。', @p_senate_work, @u_maqiuzhi, NULL, 1, 7, 'PUBLISHED', '1638-05-07 08:43:00', '1638-05-07 08:43:00');
SET @c_senate_work_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('收到。仓储签收格式我今晚前给一版，先按“入库、出库、损耗、责任人”四栏执行。', @p_senate_work, @u_xuhe, @c_senate_work_c1, 0, 3, 'PUBLISHED', '1638-05-07 09:02:00', '1638-05-07 09:02:00');
SET @c_senate_work_c1r1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('工业组可以让出两名学徒，但熟练钳工不能动。蒸汽样机还在漏汽，临时抽人会拖慢测试。', @p_senate_work, @u_linshaozhou, NULL, 2, 5, 'PUBLISHED', '1638-05-07 09:11:00', '1638-05-07 09:11:00');
SET @c_senate_work_c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('可以。执委会记录为：工业组让学徒，不抽熟练钳工。', @p_senate_work, @u_hejingyuan, @c_senate_work_c2, 0, 2, 'PUBLISHED', '1638-05-07 09:18:00', '1638-05-07 09:18:00');
SET @c_senate_work_c2r1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('医疗组要求排水沟优先，积水不处理，后面疟疾和腹泻都会增加。', @p_senate_work, @u_tangyu, NULL, 3, 9, 'PUBLISHED', '1638-05-07 09:35:00', '1638-05-07 09:35:00');
SET @c_senate_work_c3 = LAST_INSERT_ID();

INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('我可以带两个人先把低洼点标到图上，今晚用内网同步给各组。', @p_capital_drainage, @u_duwen, NULL, 1, 4, 'PUBLISHED', '1638-05-07 10:01:00', '1638-05-07 10:01:00');
SET @c_capital_drainage_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('军务组能借两名人手，但港口夜岗不能减。挖沟时间最好安排白天。', @p_capital_drainage, @u_zhaomingwei, NULL, 2, 3, 'PUBLISHED', '1638-05-07 10:20:00', '1638-05-07 10:20:00');
SET @c_capital_drainage_c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('同意，白天集中挖主沟，夜间不动港口岗。', @p_capital_drainage, @u_xuhe, @c_capital_drainage_c2, 0, 1, 'PUBLISHED', '1638-05-07 10:31:00', '1638-05-07 10:31:00');
SET @c_capital_drainage_c2r1 = LAST_INSERT_ID();

INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('教育组可以安排 6 名学徒，但需要你们列出每天必须记住的零件名称和安全规则。', @p_steam_test, @u_wenqing, NULL, 1, 6, 'PUBLISHED', '1638-05-07 10:41:00', '1638-05-07 10:41:00');
SET @c_steam_test_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('我今晚写一页，不讲原理，先讲别把手伸进传动轴。', @p_steam_test, @u_linshaozhou, @c_steam_test_c1, 0, 8, 'PUBLISHED', '1638-05-07 10:50:00', '1638-05-07 10:50:00');
SET @c_steam_test_c1r1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('农业组可以等样机，不急着上粮仓。但请给个大概时间，仓库那边要安排人力。', @p_steam_test, @u_maqiuzhi, NULL, 2, 3, 'PUBLISHED', '1638-05-07 11:04:00', '1638-05-07 11:04:00');
SET @c_steam_test_c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('如果需要记录转速，我可以拿单片机做一个简易计数器，但外壳要工坊配合。', @p_steam_test, @u_duwen, NULL, 3, 5, 'PUBLISHED', '1638-05-07 11:22:00', '1638-05-07 11:22:00');
SET @c_steam_test_c3 = LAST_INSERT_ID();

INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('签收格式可以配合工分册一起做，建议仓库门口贴当天出入库数。', @p_grain_storage, @u_xuhe, NULL, 1, 4, 'PUBLISHED', '1638-05-07 11:32:00', '1638-05-07 11:32:00');
SET @c_grain_storage_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('防霉同时要注意鼠害。医疗组发现过被污染的粮袋，不能只看干湿。', @p_grain_storage, @u_tangyu, NULL, 2, 4, 'PUBLISHED', '1638-05-07 12:10:00', '1638-05-07 12:10:00');
SET @c_grain_storage_c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('收到，今天开始把破袋和鼠咬痕迹单独登记。', @p_grain_storage, @u_maqiuzhi, @c_grain_storage_c2, 0, 2, 'PUBLISHED', '1638-05-07 12:22:00', '1638-05-07 12:22:00');
SET @c_grain_storage_c2r1 = LAST_INSERT_ID();

INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('巡逻组今晚开始领取驱蚊油。能否给一张简短说明，避免有人乱涂或者省着不用？', @p_malaria_water, @u_zhaomingwei, NULL, 1, 3, 'PUBLISHED', '1638-05-07 13:50:00', '1638-05-07 13:50:00');
SET @c_malaria_water_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('可以。我写成三条：什么时候用、涂哪里、哪些人优先。', @p_malaria_water, @u_tangyu, @c_malaria_water_c1, 0, 5, 'PUBLISHED', '1638-05-07 14:02:00', '1638-05-07 14:02:00');
SET @c_malaria_water_c1r1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('识字班可以把“煮沸饮水”做成第一批告示，贴到水井和营房。', @p_malaria_water, @u_wenqing, NULL, 2, 6, 'PUBLISHED', '1638-05-07 14:30:00', '1638-05-07 14:30:00');
SET @c_malaria_water_c2 = LAST_INSERT_ID();

INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('航海组同意提前半天给船只名单，但临时靠港的小船需要留一个例外流程。', @p_harbor_patrol, @u_guye, NULL, 1, 3, 'PUBLISHED', '1638-05-07 15:40:00', '1638-05-07 15:40:00');
SET @c_harbor_patrol_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('例外流程可以，但必须有担保人和货物简表，不然夜里无法区分商船和探子。', @p_harbor_patrol, @u_zhaomingwei, @c_harbor_patrol_c1, 0, 4, 'PUBLISHED', '1638-05-07 15:55:00', '1638-05-07 15:55:00');
SET @c_harbor_patrol_c1r1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('口令更换建议同时走内网广播，外驻点不参与，只限临高内驻。', @p_harbor_patrol, @u_duwen, NULL, 2, 2, 'PUBLISHED', '1638-05-07 16:06:00', '1638-05-07 16:06:00');
SET @c_harbor_patrol_c2 = LAST_INSERT_ID();

INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('铜料方面先问薄板和细管，厚料暂缓。请不要暴露我们真实用途。', @p_guangdong_telegraph, @u_linshaozhou, NULL, 1, 5, 'PUBLISHED', '1638-05-07 16:48:00', '1638-05-07 16:48:00');
SET @c_guangdong_telegraph_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('药材清单我会分成“必需、可替代、观察采购”三档，避免你那边被价格牵着走。', @p_guangdong_telegraph, @u_tangyu, NULL, 2, 4, 'PUBLISHED', '1638-05-07 17:03:00', '1638-05-07 17:03:00');
SET @c_guangdong_telegraph_c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('船期信息请同步给航海组，尤其是能否避开连续雨天。', @p_guangdong_telegraph, @u_guye, NULL, 3, 2, 'PUBLISHED', '1638-05-07 17:18:00', '1638-05-07 17:18:00');
SET @c_guangdong_telegraph_c3 = LAST_INSERT_ID();

INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('工坊常用词补充：锉、钻、铆、轴承、偏心、润滑。先让学徒认识危险标识。', @p_school_textbook, @u_linshaozhou, NULL, 1, 5, 'PUBLISHED', '1638-05-07 17:21:00', '1638-05-07 17:21:00');
SET @c_school_textbook_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('仓储这边要加：干、湿、霉、鼠、封、垫、称、袋。', @p_school_textbook, @u_maqiuzhi, NULL, 2, 4, 'PUBLISHED', '1638-05-07 17:28:00', '1638-05-07 17:28:00');
SET @c_school_textbook_c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('医疗告示用字要尽量少，最好配图。很多人认字慢，但能看懂图。', @p_school_textbook, @u_tangyu, NULL, 3, 6, 'PUBLISHED', '1638-05-07 17:40:00', '1638-05-07 17:40:00');
SET @c_school_textbook_c3 = LAST_INSERT_ID();

INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('执委会同意试行。请政务组先用七天，不要一次设计成永久制度。', @p_registry_coupon, @u_hejingyuan, NULL, 1, 5, 'PUBLISHED', '1638-05-07 18:40:00', '1638-05-07 18:40:00');
SET @c_registry_coupon_c1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('粮食发放可以配合户籍册，但临时工和外来帮工怎么记？', @p_registry_coupon, @u_maqiuzhi, NULL, 2, 3, 'PUBLISHED', '1638-05-07 19:02:00', '1638-05-07 19:02:00');
SET @c_registry_coupon_c2 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('临时工单列“临时名册”，只绑定工分和口粮，不先纳入正式户籍。', @p_registry_coupon, @u_xuhe, @c_registry_coupon_c2, 0, 4, 'PUBLISHED', '1638-05-07 19:16:00', '1638-05-07 19:16:00');
SET @c_registry_coupon_c2r1 = LAST_INSERT_ID();
INSERT INTO bbs_replies (content, thread_id, author_id, parent_id, floor_no, like_count, status, created_at, updated_at) VALUES ('治安册建议只由指定记录员填写，否则会变成互相告状。', @p_registry_coupon, @u_zhaomingwei, NULL, 3, 4, 'PUBLISHED', '1638-05-07 19:30:00', '1638-05-07 19:30:00');
SET @c_registry_coupon_c3 = LAST_INSERT_ID();

-- 5. 回写帖子、分区、用户统计。
UPDATE bbs_threads t SET comment_count = (SELECT COUNT(*) FROM bbs_replies r WHERE r.thread_id=t.id AND r.status='PUBLISHED'), last_replied_at = COALESCE((SELECT MAX(r.created_at) FROM bbs_replies r WHERE r.thread_id=t.id AND r.status='PUBLISHED'), t.created_at), updated_at = COALESCE((SELECT MAX(r.created_at) FROM bbs_replies r WHERE r.thread_id=t.id AND r.status='PUBLISHED'), t.updated_at) WHERE t.title IN (
'关于临高首都区一期扩建与工时调配的临时通告',
'百仞城排水沟与营房木料优先级讨论',
'小型蒸汽机样机一号炉压测试记录',
'甘薯、稻种与仓储防霉三日调拨表',
'疟疾防控与饮水煮沸制度执行细则',
'博铺港夜间巡逻与火器训练安排',
'广州外线采购与电报中继节点建议',
'第一期识字班与工匠速成课教材目录',
'临高户籍册、工分券与治安登记试行办法'
);
UPDATE bbs_categories c SET thread_count = (SELECT COUNT(*) FROM bbs_threads t WHERE t.category_id=c.id AND t.status='PUBLISHED');
UPDATE bbs_users u SET post_count = (SELECT COUNT(*) FROM bbs_threads t WHERE t.author_id=u.id AND t.status='PUBLISHED'), reply_count = (SELECT COUNT(*) FROM bbs_replies r WHERE r.author_id=u.id AND r.status='PUBLISHED');

SELECT '启明元老院演示用户、帖子、评论已插入完成。演示用户默认密码：123456' AS message;