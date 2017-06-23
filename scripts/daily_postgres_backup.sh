#!/usr/bin/env bash
echo "*** the daily database backup script is running "
#exec su postgres -c "/usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf"
NOW=$(date +"%Y%m%d_%H%M%S")
cd /tmp;/usr/bin/pg_dump -Fc -U postgres sbgc_production | gzip > sbgc_db_backup.$NOW.sql.gz
envdir /etc/wal-e.d/env /usr/local/bin/aws s3 mv sbgc_db_backup.$NOW.sql.gz s3://sbgc/$1/
