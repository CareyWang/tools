#!/bin/bash

sudo apt-get update

# 安装 php7.3
sudo apt-get install -y software-properties-common
sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install -y php7.3 php7.3-fpm php7.3-mysql php7.3-curl php7.3-soap php7.3-xml php7.3-zip php7.3-gd php7.3-mbstring php7.3-json -y

# 安装 Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
# composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
