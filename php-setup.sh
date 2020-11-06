#!/bin/bash

sudo yum update      

sudo service mysqld stop
sudo yum -y erase mysql-config mysql55-server mysql55-libs mysql55
sudo yum -y install mysql57-server mysql57
sudo service mysqld start
sudo chkconfig mysqld on

sudo yum -y install php72 php72-mbstring php72-pdo php72-mysqlnd
sudo alternatives --set php /usr/bin/php-7.2
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer
curl -OL https://cli-assets.heroku.com/heroku-linux-x64.tar.gz
tar zxf heroku-linux-x64.tar.gz && rm -f heroku-linux-x64.tar.gz
sudo mv heroku /usr/local
echo 'PATH=/usr/local/heroku/bin:$PATH' >> $HOME/.bash_profile
source $HOME/.bash_profile > /dev/null
