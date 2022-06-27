#!/bin/bash

cd ~

sudo yum -y update


# uninstall MariaDB, install MySQL 5.7
sudo service mariadb stop
sudo yum -y erase mariadb-config mariadb-common mariadb-libs mariadb
sudo yum -y localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
sudo yum-config-manager --disable mysql80-community
sudo yum-config-manager --enable mysql57-community
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum -y install mysql-community-server
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service

DB_PASSWORD=$(sudo grep "A temporary password is generated" /var/log/mysqld.log | sed -s 's/.*root@localhost: //')
mysql -uroot -p${DB_PASSWORD} --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'TB@shibuya1';uninstall plugin validate_password;set password for root@localhost=password('');"


# install php
sudo yum remove -y php php-*
sudo amazon-linux-extras disable lamp-mariadb10.2-php7.2
sudo amazon-linux-extras install php8.0 -y
sudo amazon-linux-extras enable php8.0
sudo yum install php-mbstring php-pdo php-mysqlnd php-bcmath php-xml -y
sudo rm -f /etc/php.d/30-xdebug.ini


# install composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer


# install heroku
curl -OL https://cli-assets.heroku.com/heroku-linux-x64.tar.gz
tar zxf heroku-linux-x64.tar.gz && rm -f heroku-linux-x64.tar.gz
sudo mv heroku /usr/local
echo 'export PATH=$PATH:/usr/local/heroku/bin' >> $HOME/.bash_profile


# reload shell config
source $HOME/.bash_profile
