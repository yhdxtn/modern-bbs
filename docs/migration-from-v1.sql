-- 从旧版 modern_bbs 迁移到新版 qiming_bbs 的参考脚本
-- 用法：先创建 qiming_bbs，并运行新版项目一次，让表结构创建完成；然后按需执行下面语句。
-- 注意：如果你旧库不是 modern_bbs，请把 modern_bbs 改成你的旧数据库名。

CREATE DATABASE IF NOT EXISTS qiming_bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 1. 迁移用户
INSERT INTO qiming_bbs.bbs_users
(id, username, normalized_username, password_hash, nickname, avatar_url, bio, role, status, created_at, updated_at)
SELECT id,
       username,
       LOWER(username),
       password_hash,
       nickname,
       avatar_url,
       bio,
       role,
       'ACTIVE',
       created_at,
       COALESCE(created_at, NOW())
FROM modern_bbs.bbs_users
ON DUPLICATE KEY UPDATE
nickname = VALUES(nickname),
avatar_url = VALUES(avatar_url),
bio = VALUES(bio),
role = VALUES(role),
updated_at = NOW();

-- 2. 迁移分区
INSERT INTO qiming_bbs.bbs_categories
(id, name, slug, description, sort_order, status, created_at, updated_at)
SELECT id, name, slug, description, sort_order, 'ACTIVE', NOW(), NOW()
FROM modern_bbs.bbs_categories
ON DUPLICATE KEY UPDATE
name = VALUES(name),
description = VALUES(description),
sort_order = VALUES(sort_order),
status = 'ACTIVE';

-- 3. 迁移主题帖元数据
INSERT INTO qiming_bbs.bbs_threads
(id, title, author_id, category_id, view_count, comment_count, pinned, status, last_replied_at, created_at, updated_at)
SELECT id,
       title,
       author_id,
       category_id,
       views,
       comment_count,
       pinned,
       'PUBLISHED',
       updated_at,
       created_at,
       updated_at
FROM modern_bbs.bbs_posts
ON DUPLICATE KEY UPDATE
title = VALUES(title),
category_id = VALUES(category_id),
view_count = VALUES(view_count),
comment_count = VALUES(comment_count),
pinned = VALUES(pinned),
updated_at = VALUES(updated_at);

-- 4. 迁移主题帖正文
INSERT INTO qiming_bbs.bbs_thread_contents (thread_id, content)
SELECT id, content
FROM modern_bbs.bbs_posts
ON DUPLICATE KEY UPDATE content = VALUES(content);

-- 5. 迁移回复
INSERT INTO qiming_bbs.bbs_replies
(id, thread_id, author_id, content, status, created_at, updated_at)
SELECT id, post_id, author_id, content, 'PUBLISHED', created_at, created_at
FROM modern_bbs.bbs_comments
ON DUPLICATE KEY UPDATE
content = VALUES(content),
updated_at = VALUES(updated_at);

-- 6. 重新校准统计字段
UPDATE qiming_bbs.bbs_threads t
SET comment_count = (
    SELECT COUNT(*) FROM qiming_bbs.bbs_replies r WHERE r.thread_id = t.id AND r.status = 'PUBLISHED'
);

UPDATE qiming_bbs.bbs_categories c
SET thread_count = (
    SELECT COUNT(*) FROM qiming_bbs.bbs_threads t WHERE t.category_id = c.id AND t.status = 'PUBLISHED'
);

UPDATE qiming_bbs.bbs_users u
SET post_count = (
    SELECT COUNT(*) FROM qiming_bbs.bbs_threads t WHERE t.author_id = u.id AND t.status = 'PUBLISHED'
),
reply_count = (
    SELECT COUNT(*) FROM qiming_bbs.bbs_replies r WHERE r.author_id = u.id AND r.status = 'PUBLISHED'
);
