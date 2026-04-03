 ```
sudo docker network create wp-net
sudo docker volume create  wp-db
sudo docker volume create  wp-data

sudo docker run -d --name wp-db --network wp-net --restart always \
  -v wp-db:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wp_user
  -e MYSQL_PASSWORD=wp_pass
  mariadb:10.11

sudo docker run -d --name wp-app --network wp-net --restart always \
  -p 8080:80 \
  -v wp-data:/var/www/html \
  -e WORDPRESS_DB_HOST=wp-db \
  -e WORDPRESS_DB_USER=root \
  -e WORDPRESS_DB_PASSWORD=secret \
  wordpress
```
