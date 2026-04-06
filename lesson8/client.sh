#!/usr/bin/env bash
export DOMAIN="mysite.local"
export SERVER_IP="192.168.56.100"

sed -i "/$DOMAIN/d" /etc/hosts
echo "$SERVER_IP $DOMAIN www.$DOMAIN" >> /etc/hosts

while [ ! -f /vagrant/server.crt ]; do
  sleep 1
done

apt-get update && apt-get install -y ca-certificates curl
cp /vagrant/server.crt /usr/local/share/ca-certificates/server.crt
update-ca-certificates

curl -I https://$DOMAIN