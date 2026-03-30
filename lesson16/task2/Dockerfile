FROM debian:11

RUN apt-get update && apt-get install nginx -y

RUN mkdir -p /opt/www

COPY index.html /opt/www/index.html

COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]

