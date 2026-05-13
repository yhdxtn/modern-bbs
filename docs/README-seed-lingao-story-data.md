# 启明元老院 BBS 演示数据

包含：

- 14 个原创演示元老用户
- 9 个分区主题帖
- 对应评论区与楼中回复
- 按临高登陆点、百仞城、博铺港、广东、台湾、济州岛、日本、越南等设定分布

这些内容是原创演示文本，没有复制小说原文或原著角色对白。

## 执行方式

把本目录里的 `seed-lingao-story-data.sql` 放到：

```text
D:/github/modern-bbs/docs/seed-lingao-story-data.sql
```

进入 MySQL：

```powershell
mysql --default-character-set=utf8mb4 -uroot -proot
```

执行：

```sql
SOURCE D:/github/modern-bbs/docs/seed-lingao-story-data.sql;
```

演示用户默认密码：

```text
123456
```

如果项目的 MySQL 密码不是 root，请照你的实际密码进入 MySQL。
