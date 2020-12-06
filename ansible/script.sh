#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=IL/ST=IL-Center/L=Tel-Aviv/O=Surecom/OU=DevOps/CN=lb-nginx" -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
apt-get update -y && apt-get install -y libnss3-tools
mkdir -p $HOME/.pki/nssdb && chmod 700 $HOME/.pki/nssdb
certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n nginx-selfsigned.crt -i /etc/ssl/certs/nginx-selfsigned.crt
cat << 'EOF' > /etc/nginx/nginx.conf
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format upstream_time  '$remote_addr - $remote_user [$time_local] '
                              '"$request" $status $body_bytes_sent '
                              '"$http_referer" "$http_user_agent" '
                              'rt=$request_time uct="$upstream_connect_time" uht="$upstream_header_time" urt="$upstream_response_time"';

    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;

        ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
        ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                try_files $uri $uri/ =404;
        }
        gzip on;
        access_log /spool/logs/nginx-access.log upstream_time;
    }

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
EOF
