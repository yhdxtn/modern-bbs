#!/usr/bin/env bash
set -e
mysql --default-character-set=utf8mb4 -uroot -proot < docs/seed-1628-lingao-story.sql
