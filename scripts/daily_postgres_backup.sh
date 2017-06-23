#!/usr/bin/env bash
echo "*** the daily database backup script is running "
NOW=$(date +"%Y%m%d_%H%M%S")
cd /tmp;/usr/bin/pg_dump -Fc -U postgres sbgc_production | gzip > sbgc_db_backup.$NOW.sql.gz
envdir /etc/wal-e.d/env /usr/local/bin/aws s3 mv sbgc_db_backup.$NOW.sql.gz s3://sbgc/$1/
