#!/bin/bash

printf "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri\n" >> ~/.gemrc
gem install rails -v 5.2.0
sudo service mysqld stop
sudo yum -y erase mysql-config mysql55-server mysql55-libs mysql55
sudo yum -y install mysql57-server mysql57
sudo service mysqld start
sudo chkconfig mysqld on
sudo yum install -y mysql-devel
