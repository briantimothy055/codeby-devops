#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -y rsync

mkdir -p /opt/store/mysql
chown -R vagrant:vagrant /opt/store/mysql

echo "Waiting for key from server..."
while [ ! -f /vagrant/server_key.pub ]; do sleep 2; done

mkdir -p /home/vagrant/.ssh
cat /vagrant/server_key.pub >> /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh