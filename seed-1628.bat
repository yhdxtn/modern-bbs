@echo off
chcp 65001 >nul
echo 导入 1628 年剧情种子数据...
mysql --default-character-set=utf8mb4 -uroot -proot < docs\seed-1628-lingao-story.sql
echo 完成。如果失败，请确认 MySQL 密码是否为 root。
pause
