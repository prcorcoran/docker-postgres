#!/bin/bash
echo "************** Starting WAL-E support for Postgres"
if [ "$AWS_ACCESS_KEY_ID" = "" ]
then
    echo "AWS_ACCESS_KEY_ID does not exist"
else
    if [ "$AWS_SECRET_ACCESS_KEY" = "" ]
    then
        echo "AWS_SECRET_ACCESS_KEY does not exist"
    else
        if [ "$WALE_S3_PREFIX" = "" ]
        then
            echo "WALE_S3_PREFIX does not exist"
        else
            # Assumption: the group is trusted to read secret information
	    sudo rm -r env
            umask u=rwx,g=rx,o=
            mkdir -p env

            echo "$AWS_SECRET_ACCESS_KEY" > env/AWS_SECRET_ACCESS_KEY
            echo "$AWS_ACCESS_KEY_ID" > env/AWS_ACCESS_KEY_ID
            echo "$WALE_S3_PREFIX" > env/WALE_S3_PREFIX
            sudo chown -R root:postgres env
            
            # wal-e specific note: just put this into out postgresql.conf file 
            #echo "wal_level = archive" >> /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf
            #echo "archive_mode = on" >> /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf
            #echo "archive_command = 'envdir /etc/wal-e.d/env /usr/local/bin/wal-e wal-push %p'" >> /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf
            #echo "archive_timeout = 60" >> /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf/postgresql.conf
            sudo rm -r cron
	    umask u=rwx,g=rx,o=
            mkdir -p cron
	    cat > cron/wal-e << EOL
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 2 * * * postgres envdir /etc/wal-e.d/env wal-e backup-push /var/lib/postgresql/9.4/main
0 3 * * * postgres envdir /etc/wal-e.d/env wal-e delete --confirm retain 7
EOL
           sudo chown -R root:postgres cron
        fi
    fi
fi
