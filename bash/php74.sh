#!/bin/bash
# curl -fsSL https://git.io/JIRlS | bash
# https://cdn.jsdelivr.net/gh/CareyWang/tools@master/bash/php74.sh

# add-apt-repository ppa:ondrej/php -y
apt update
apt install -y php7.4 php7.4-fpm php7.4-mysql php7.4-curl php7.4-xml php7.4-zip php7.4-gd php7.4-mbstring php7.4-json php7.4-redis php7.4-bcmath -y

# 安装 Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
# composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
