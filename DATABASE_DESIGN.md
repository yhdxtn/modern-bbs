# 数据库 v2 设计说明

这个版本把原来的“用户 / 分区 / 帖子 / 评论”简单结构升级成更适合长期运营的论坛结构。当前前台和后台仍然能直接运行，同时数据库已经预留了多人、多权限、标签、收藏、通知、审计日志、附件等后续扩展能力。

## 主要改动

### 1. 主题帖正文拆表

旧版把标题、正文、统计字段都放在 `bbs_posts`。新版改为：

- `bbs_threads`：主题帖元数据，例如标题、作者、分区、浏览数、回复数、置顶、状态、更新时间。
- `bbs_thread_contents`：主题帖正文，大文本单独存放。

这样首页列表只查元数据，不必每次把长正文一起读出来，后面帖子数量上来后会更稳。

### 2. 回复表独立命名

旧版 `bbs_comments` 改为新版 `bbs_replies`，更符合 BBS 语义。回复表预留了：

- `parent_id`：以后可做楼中楼。
- `floor_no`：楼层号。
- `status`：审核、隐藏、删除都可以靠状态扩展。

### 3. 用户体系更完整

`bbs_users` 增加：

- `normalized_username`：用户名唯一性不受大小写影响。
- `status`：ACTIVE、BANNED、DISABLED。
- `post_count`、`reply_count`：用户发帖/回复统计。
- `last_login_at`：最近登入时间。

同时预留：

- `bbs_roles`
- `bbs_user_roles`

当前代码仍保留 `role` 字段，方便简单判断管理员；以后要做“执委会、分区执事、普通元老、游客”等多角色时，可以逐步迁移到 RBAC。

### 4. 分区支持层级

`bbs_categories` 增加 `parent_id`，以后可以做：

```text
工业建设
  ├─ 电力
  ├─ 冶金
  └─ 机械制造
```

当前页面仍显示一级分区，不影响使用。

### 5. 预留长期运营功能表

新版数据库预留：

- `bbs_tags`、`bbs_thread_tags`：标签系统。
- `bbs_reactions`：点赞、赞同、反对、收藏外的互动。
- `bbs_bookmarks`：收藏主题。
- `bbs_notifications`：站内通知。
- `bbs_attachments`：附件上传。
- `bbs_audit_logs`：后台操作审计。
- `bbs_login_logs`：登入日志。

这些表当前不强制使用，但以后网站发展起来时不用推翻重做数据库。

## 推荐索引思路

高频列表页：

```sql
bbs_threads(category_id, pinned, updated_at)
bbs_threads(author_id, created_at)
bbs_replies(thread_id, created_at)
```

搜索：

```sql
bbs_thread_contents FULLTEXT(content)
bbs_replies FULLTEXT(content)
```

用户与权限：

```sql
bbs_users(normalized_username)
bbs_user_roles(user_id, role_id)
```

后台审计：

```sql
bbs_audit_logs(actor_id, created_at)
bbs_audit_logs(target_type, target_id)
```

## 新库名

新版默认使用：

```sql
qiming_bbs
```

创建数据库：

```sql
CREATE DATABASE IF NOT EXISTS qiming_bbs
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
```

如果你想继续用旧库 `modern_bbs`，可以把 `application.yml` 里的 JDBC URL 改回去，但更推荐新库，避免旧表结构冲突。

## 生产环境建议

开发阶段：

```yaml
spring.jpa.hibernate.ddl-auto: update
```

上线后建议改为：

```yaml
spring.jpa.hibernate.ddl-auto: validate
```

然后用 `docs/database-v2.sql` 和以后每次变更的迁移 SQL 管理数据库，不要让程序自动改生产库。

## v3：态势图和个人驻点数据

新增表：

- `bbs_site_settings`：站点级配置表，目前用于保存新世界时间名称与 UTC 偏移。后续可扩展为站点公告、注册开关、审核开关等配置。
- `bbs_council_locations`：管理员维护的元老分布基数表，按 `scope` 分为 `WORLD` 与 `CHINA` 两类。首页地图会读取该表，并叠加个人档案中的驻点登记数。

用户表新增字段：

- `station_scope`：个人驻点范围，`WORLD` 或 `CHINA`。
- `station_name`：个人驻点名称。
- `station_elder_count`：个人登记的同行元老数量。

设计理由：

- 首页地图不再依赖前端静态文件，后台修改后立即生效。
- 时间偏移进入数据库，后续可继续扩展为“新世界纪年”“船队时间”“元老院工作日历”。
- 个人主页保存驻点信息，为后续自动汇总、审核、分区权限、地区频道做准备。
