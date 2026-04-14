#!/usr/bin/env bash

export DOMAIN="mysite.local"

apt-get update
apt-get install -y apache2 openssl

mkdir -p /etc/apache2/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/apache2/ssl/apache.key \
  -out /etc/apache2/ssl/apache.crt \
  -subj "/C=RU/ST=Moscow/L=Moscow/O=DevOps/OU=IT/CN=$DOMAIN" \
  -addext "subjectAltName = DNS:$DOMAIN,DNS:www.$DOMAIN"

cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    # HTTP to HTTPS redirect
    Redirect permanent / https://$DOMAIN/
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/apache.crt
    SSLCertificateKeyFile /etc/apache2/ssl/apache.key

    # WWW to Non-WWW redirect
    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]
    RewriteRule ^(.*)$ https://%1$1 [R=301,L]
</VirtualHost>
EOF

a2enmod ssl rewrite
a2ensite 000-default
systemctl restart apache2

cp /etc/apache2/ssl/apache.crt /vagrant/server.crt