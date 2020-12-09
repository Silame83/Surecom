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

        server_name _;

        location / {
                proxy_pass "http://0.0.0.0:8080";
                proxy_set_header Host $host;
                proxy_redirect          off;
                proxy_set_header        X-NginX-Proxy true;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
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
