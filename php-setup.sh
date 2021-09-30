#!/bin/bash

sudo yum update -y     

sudo service mysqld stop
sudo yum -y erase mysql-config mysql55-server mysql55-libs mysql55
sudo yum -y install mysql57-server mysql57
sudo service mysqld start
sudo chkconfig mysqld on

sudo yum -y install php73 php73-mbstring php73-pdo php73-mysqlnd
sudo alternatives --set php /usr/bin/php-7.3
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer
curl -OL https://cli-assets.heroku.com/heroku-linux-x64.tar.gz
tar zxf heroku-linux-x64.tar.gz && rm -f heroku-linux-x64.tar.gz
sudo mv heroku /usr/local
echo 'PATH=/usr/local/heroku/bin:$PATH' >> $HOME/.bash_profile
source $HOME/.bash_profile > /dev/null
