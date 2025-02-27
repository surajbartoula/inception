# #!/usr/bin/env bash

# mkdir $CERT_DIR
# openssl req -x509 -newkey rsa:2048 -days 365 -nodes -keyout $CERT_KEY -out $CERT -subj /CN=$HOST_NAME

# echo "server {
#         listen 443 ssl http2;
#         server_name $HOST_LOGIN;

#         root   $WP_ROUTE;
#         index index.php index.html index.htm index.nginx-debian.html;

#         ssl_protocols TLSv1.2;
#         ssl_certificate  $CERT;
#         ssl_certificate_key  $CERT_KEY;" > $NGINX_CONF;
# echo '
#         location / {
#                 try_files $uri $uri/ /index.php?$args =404;
#         }

#         location ~ \.php$ {
#                 include snippets/fastcgi-php.conf;
#                 fastcgi_pass wordpress:9000;
#         }
# }' >> $NGINX_CONF;

# nginx -g "daemon off;"
#!/usr/bin/env bash

# Ensure required environment variables are set
if [[ -z "$CERT_DIR" || -z "$CERT" || -z "$CERT_KEY" || -z "$HOST_NAME" || -z "$HOST_LOGIN" || -z "$WP_ROUTE" || -z "$NGINX_CONF" ]]; then
    echo "Error: One or more required environment variables are not set."
    exit 1
fi

# Create certificate directory
sudo mkdir -p "$CERT_DIR"

# Generate SSL certificate
sudo openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
    -keyout "$CERT_KEY" -out "$CERT" -subj "/CN=$HOST_NAME"

# Create Nginx configuration using tee
echo "server {
        listen 443 ssl http2;
        server_name $HOST_LOGIN;

        root   $WP_ROUTE;
        index index.php index.html index.htm index.nginx-debian.html;

        ssl_protocols TLSv1.2;
        ssl_certificate  $CERT;
        ssl_certificate_key  $CERT_KEY;
}" | sudo tee "$NGINX_CONF" > /dev/null

# Append location blocks using tee
echo '
        location / {
                try_files $uri $uri/ /index.php?\$args =404;
        }

        location ~ \.php\$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass wordpress:9000;
        }
}' | sudo tee -a "$NGINX_CONF" > /dev/null

# Restart Nginx to apply changes
sudo systemctl restart nginx