#!/bin/bash

printf "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri\n" >> ~/.gemrc
sudo service mysqld stop
sudo yum -y erase mysql-config mysql55-server mysql55-libs mysql55
sudo yum -y install mysql57-server mysql57
sudo service mysqld start
sudo chkconfig mysqld on
sudo yum install -y mysql-devel

cd ~
git clone git://github.com/sstephenson/rbenv.git .rbenv
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

export CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc --disable-install-capi"
rbenv install -v 2.7.3
unset CONFIGURE_OPTS

rbenv global 2.7.3
gem install rails -v 5.2.0
gem pristine --all
