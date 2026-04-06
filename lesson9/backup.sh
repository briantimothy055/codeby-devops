#!/bin/bash
DB_NAME="real_db"
BACKUP_DIR="/opt/mysql_backup"
REMOTE_STORE="192.168.56.101"
REMOTE_DIR="/opt/store/mysql"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/db_backup_$TIMESTAMP.sql"

mysqldump "$DB_NAME" > "$BACKUP_FILE"
rsync -avz -e 'ssh -i /home/vagrant/.ssh/id_rsa -o StrictHostKeyChecking=no' "$BACKUP_DIR/" "vagrant@$REMOTE_STORE:$REMOTE_DIR/"