#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y mariadb-server rsync

mysql -e "CREATE DATABASE IF NOT EXISTS real_db;"
mysql -e "CREATE TABLE IF NOT EXISTS real_db.users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));"
mysql -e "TRUNCATE TABLE real_db.users;"
mysql -e "INSERT INTO real_db.users (name) VALUES ('A'), ('B'), ('C'), ('D'), ('E');"

cat <<EOF > /home/vagrant/.my.cnf
[client]
user=root
password=
EOF
chown vagrant:vagrant /home/vagrant/.my.cnf
chmod 600 /home/vagrant/.my.cnf

mkdir -p /opt/mysql_backup
chown vagrant:vagrant /opt/mysql_backup

if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
    sudo -u vagrant ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
    sudo chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
    sudo chmod 600 /home/vagrant/.ssh/id_rsa
    cp /home/vagrant/.ssh/id_rsa.pub /vagrant/server_key.pub
fi

cp /vagrant/backup.sh /usr/local/bin/backup.sh
chmod +x /usr/local/bin/backup.sh
chown vagrant:vagrant /usr/local/bin/backup.sh

(crontab -l 2>/dev/null; echo "0 * * * * /usr/local/bin/backup.sh") | crontab -