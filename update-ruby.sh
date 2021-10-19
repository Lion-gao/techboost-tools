#!/bin/sh

cd ~

# uninstall rvm
if command -v rvm &> /dev/null; then
    rvm seppuku
fi


# install rbenv
if ! command -v rbenv &> /dev/null; then
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    source ~/.bash_profile
fi

# install ruby v2.7.3
rbenv install 2.7.3 -s


# update ruby version
cd ~/environment/pictgram
rbenv local 2.7.3
sed -e "s/ruby .*/ruby '2.7.3'/" -i Gemfile

# install bundler
gem install bundler -v `tail -n1 Gemfile.lock`
bundle install
