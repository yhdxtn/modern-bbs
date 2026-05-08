# 1628 年剧情种子数据说明

这个脚本会向 `qiming_bbs` 插入一批原创拟制的 1628 年 D日—D+95日剧情数据：

- 23 个元老用户，昵称为中文名，头像为空时前端显示昵称首字。
- 12 个分区，包括临高首都区建设、通信电力、广州外务站、黎区工作等。
- 25 篇帖子，发布时间全部在 1628 年 9 月至 12 月。
- 83 条评论和楼中回复，时间也全部在 1628 年。
- 自动把首页“新世界时间”设置到 1628-12-20 18:00 左右。

## 执行方法

先启动过一次项目，让 JPA 自动建表；或者先执行 `schema.sql` / `docs/database-v2.sql`。

然后在 PowerShell / CMD 进入 MySQL：

```powershell
mysql --default-character-set=utf8mb4 -uroot -proot
```

进入后执行：

```sql
SOURCE D:/github/modern-bbs/docs/seed-1628-lingao-story.sql;
```

## 默认账号

脚本新增的剧情用户默认密码均为：

```text
123456
```

例如可以登录：

```text
账号：maqianzhu
密码：123456
```

## 重复执行

脚本会先删除标题以 `【1628·` 开头的旧剧情帖，再重新插入，不会删除你自己手动发的普通帖子。
