#!/bin/bash

# set MySQL user and password
read -p "MySQL User Name?: " MY_USERNAME < /dev/tty
read -p "MySQL Password?: " MY_PASSWORD < /dev/tty
echo "Your MySQL configuration: "
echo "  User Name: $MY_USERNAME"
echo "  Password: $MY_PASSWORD"
read -p "ok? (y/N): " yn < /dev/tty
if [[ ${yn} =~ [yY] ]]; then
 : # continue
else
  echo "Please run this script again."
  exit 1
fi

# create .env
if [ ! -f ./.env.example ]; then 
  echo ".env.example not found."
  echo "operation terminated."
  exit 1
else
  cp .env.example .env
fi

# set .env variables
ed - .env <<EOF
,s/^APP_DEBUG.*$/APP_DEBUG=false/g
,s/^DB_DATABASE.*$/DB_DATABASE=mynews_production/g
,s/^DB_USERNAME.*$/DB_USERNAME=${MY_USERNAME}/g
,s/^DB_PASSWORD.*$/DB_PASSWORD=${MY_PASSWORD}/g
wq
EOF

# composer install
echo "Composer install..."
if [ ! -f /usr/bin/composer ]; then 
  echo "/usr/bin/composer not found."
  echo "operation terminated."
  exit 1
else
  composer install
fi

# laravel setup
echo "Laravel setup..."
php artisan key:generate
php artisan migrate:fresh
php artisan config:cache
php artisan storage:link
npm install
npm run dev

# create document root link
echo "Creating nginx document root link..."
if [ ! -d /usr/share/nginx ]; then 
  echo "/usr/share/nginx not found."
  echo "nginx might be not installed."
  echo "operation terminated."
  exit 1
else
  if [ -e /usr/share/nginx/public ]; then 
    sudo rm /usr/share/nginx/public
  fi
  sudo ln -s $(pwd)/public /usr/share/nginx/public
fi

echo "production_setup_laravel.sh successfully completed."

