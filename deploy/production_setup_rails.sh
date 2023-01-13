#!/bin/bash

# check current rails directory
echo "Check current directory..."
if [ ! -f ./Gemfile ]; then 
  echo "$(pwd) might be not Rails project."
  echo "operation terminated."
  exit 1
fi

rbenv rehash

if [ -z ${PICTGRAM_DATABASE_PASSWORD} ]; then 
  echo "Please set PICTGRAM_DATABASE_PASSWORD as a environemnt variable."
  echo "operation terminated."
  exit 1
fi

# regenerate secret_key_base
echo "Creating new config/credentials.yml.enc..."
if [ -f ./config/credentials.yml.enc ]; then 
  rm ./config/credentials.yml.enc
fi
if [ -f ./config/master.key ]; then 
  rm ./config/master.key
fi

EDITOR="ed" rails credentials:edit <<EOF > /dev/null
wq
EOF
echo "done."

# migration
echo "Rails migration..."
rails db:migrate RAILS_ENV=production
# cache clear and precompile
rails tmp:cache:clear
rails assets:precompile RAILS_ENV=production
echo "done."

# create config/puma/production.rb
echo "Creating config/puma/production.rb..."
if [ ! -d ./config/puma ]; then 
  mkdir ./config/puma
fi
tee ./config/puma/production.rb <<EOF > /dev/null
environment "production"

bind "unix:///usr/share/nginx/rails/tmp/sockets/puma.sock"
daemonize
EOF
echo "done."

# create document root link
echo "Creating nginx document root link..."
if [ ! -d /usr/share/nginx ]; then 
  echo "/usr/share/nginx not found."
  echo "nginx might be not installed."
  echo "operation terminated."
  exit 1
fi
if [ -e /usr/share/nginx/rails ]; then
  sudo rm /usr/share/nginx/rails
fi
sudo ln -s $(pwd) /usr/share/nginx/rails

# run puma with production setting
if [ ! -d ./tmp/sockets ]; then 
  mkdir ./tmp/sockets
fi

puma -C $(pwd)/config/puma/production.rb

# wait a wile
sleep 3

#  check socket
if [ ! -e ./tmp/sockets/puma.sock ]; then 
  echo "$(pwd)/tmp/sockets/puma.sock not found."
  echo "operation terminated."
  exit 1
fi

echo "production_setup_rails.sh successfully completed."

