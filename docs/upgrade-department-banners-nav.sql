-- 修复顶部导航显示不全，并新增“分区负责人宣传图轮播”数据库结构
CREATE DATABASE IF NOT EXISTS qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qiming_bbs;
SET NAMES utf8mb4;

-- 1. 给分区表增加负责人账号字段。MySQL 8.0.46 不支持 ADD COLUMN IF NOT EXISTS，因此用动态 SQL 兼容。
SET @has_manager_col := (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bbs_categories' AND COLUMN_NAME = 'manager_user_id'
);
SET @ddl := IF(@has_manager_col = 0,
    'ALTER TABLE bbs_categories ADD COLUMN manager_user_id BIGINT NULL AFTER executive_only',
    'SELECT "manager_user_id already exists"'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 补负责人外键。
SET @has_manager_fk := (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bbs_categories' AND CONSTRAINT_NAME = 'fk_category_manager'
);
SET @ddl := IF(@has_manager_fk = 0,
    'ALTER TABLE bbs_categories ADD CONSTRAINT fk_category_manager FOREIGN KEY (manager_user_id) REFERENCES bbs_users(id) ON DELETE SET NULL',
    'SELECT "fk_category_manager already exists"'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3. 创建部门宣传图轮播表。
CREATE TABLE IF NOT EXISTS bbs_department_banners (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_id BIGINT NOT NULL,
    title VARCHAR(80) NOT NULL,
    subtitle VARCHAR(220),
    image_url VARCHAR(500) NOT NULL,
    link_text VARCHAR(40),
    link_url VARCHAR(500),
    sort_order INT NOT NULL DEFAULT 0,
    visible BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_department_banner_category FOREIGN KEY (category_id) REFERENCES bbs_categories(id) ON DELETE CASCADE,
    UNIQUE KEY uk_department_banner_category_title (category_id, title),
    KEY idx_department_banner_category_sort (category_id, visible, sort_order),
    KEY idx_department_banner_visible (visible)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. 默认把 admin 指定为各分区负责人，后续可在后台分区管理里改成各部门负责人账号。
UPDATE bbs_categories c
JOIN bbs_users u ON u.username = 'admin'
SET c.manager_user_id = u.id
WHERE c.manager_user_id IS NULL;

-- 5. 初始化几张部门宣传图，负责人或管理员可在“宣传图管理”中替换为自己上传的图片。
INSERT INTO bbs_department_banners (category_id, title, subtitle, image_url, link_text, link_url, sort_order, visible) VALUES
(9, '临高首都区一期扩建', '围绕登陆点、百仞城与博铺港建立首都区秩序，优先推进居住、防疫、仓储和港口调度。', 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=9', 10, 1),
(2, '工业委员会设备攻关', '蒸汽动力、机械维修、盐硝化工与基础电力项目集中归档，方便各组协同推进。', 'https://images.unsplash.com/photo-1513828583688-c52646db42da?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=2', 10, 1),
(3, '农业与物资周转计划', '粮食、甘蔗、仓储、防霉与后勤配送按临高首都区需求统筹调配。', 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=3', 10, 1),
(4, '医疗卫生检疫体系', '检疫、饮水、药品、外伤处理和传染病预警统一登记，确保临高首都区公共卫生稳定。', 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=4', 10, 1),
(5, '港口防御与巡逻制度', '军务安保分区集中讨论营地防御、港口警戒、治安巡逻和电报预警。', 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=5', 10, 1),
(6, '航海贸易与外驻电报网', '港口、船只、航线、外部接触和外驻元老电报回报在此集中整理。', 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1600&q=80', '进入分区', '/?categoryId=6', 10, 1)
ON DUPLICATE KEY UPDATE
subtitle = VALUES(subtitle),
image_url = VALUES(image_url),
link_text = VALUES(link_text),
link_url = VALUES(link_url),
sort_order = VALUES(sort_order),
visible = VALUES(visible);
