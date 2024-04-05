#!/bin/bash

DB_HOST="HOST"
DB_USER="USER"
DB_PASSWORD="PASSWORD"

echo "insert data into temp table"
mysql -h ${DB_HOST} -u ${DB_USER) -p${DB_PASSWORD} < ./create_temp_talbe.sql

sleep 30

# 데이터 백업
echo "data dump"
mysqldump -h ${DB_HOST} -u ${DB_USER) -p${DB_PASSWORD} \ 
  --set-gtid-purged=OFF \
  [DATABASE_NAME] [TABLE] \
  --default-character-set utf8 | gzip > dunmp_data.sql.gz

sleep 30

gzip -d dunmp_data.sql.gz

# 데이터 복원
echo "data import"

mysql -h ${DB_HOST} -u ${DB_USER) -p${DB_PASSWORD} [DATABASE] < dunmp_data.sql
