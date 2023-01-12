#!/bin/bash

# set domain name
read -p "Your domain name?: " MYDOMAIN < /dev/tty
read -p "Your email address?: " MYEMAIL < /dev/tty
echo "Your domain and email"
echo "  Domain: $MYDOMAIN"
echo "  Email: $MYEMAIL"
read -p "ok? (y/N): " yn < /dev/tty
if [[ ${yn} =~ [yY] ]]; then
 : # continue
else
  echo "Please run this script again."
  exit 1
fi

# modify /etc/nginx/nginx.conf
NGINX_CONF=/etc/nginx/nginx.conf
if [ ! -f ${NGINX_CONF} ]; then
  echo "/etc/nginx/nginx.conf not found."
  echo "nginx might be not installed."
  exit 1
fi

sudo cp ${NGINX_CONF} ${NGINX_CONF}.`date +%Y%m%d%H%M%S`

sudo ed - ${NGINX_CONF} <<EOF
,s/server_name  _/server_name ${MYDOMAIN}/g
wq
EOF

# run Let's Encrypt certbot
echo "install Let's Encrypt certificates"
sudo certbot --nginx --non-interactive --agree-tos --email ${MYEMAIL} --domains ${MYDOMAIN}

# check
sudo ls /etc/letsencrypt/live/${MYDOMAIN}/privkey.pem > /dev/null
if [ $? -ne 0  ]; then
  echo "/etc/letsencrypt/live/${MYDOMAIN}/privkey.pem not found."
  echo "Please check your domain name ${MYDOMAIN}"
  exit 1
fi

# restart nginx
sudo systemctl restart nginx

echo "ssl_setup.sh successfully completed."
