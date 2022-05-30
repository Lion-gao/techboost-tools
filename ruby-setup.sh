#!/bin/bash

cd ~


# uninstall MariaDB, install MySQL 5.7
sudo service mysqld stop
sudo yum -y erase mysql-config mysql55-server mysql55-libs mysql55
sudo yum -y install mysql57-server mysql57
sudo service mysqld start
sudo chkconfig mysqld on
sudo yum install -y mysql-devel


# uninstall rvm
if command -v rvm &> /dev/null; then
  rvm seppuku --force
  source ~/.bash_profile
fi


# install rbenv
if ! command -v rbenv &> /dev/null; then
  git clone https://github.com/sstephenson/rbenv.git .rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  source ~/.bash_profile
fi


# install ruby
export CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc"
rbenv install 2.7.3 -s
unset CONFIGURE_OPTS

rbenv global 2.7.3


# install rails
printf "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri\n" >> ~/.gemrc
gem install rails -v 5.2.0
