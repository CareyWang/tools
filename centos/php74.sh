#!/bin/bash 

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-8.rpm
dnf install dnf-utils -y

yum install php74-php php74-php-fpm php74-php-mysql php74-php-curl php74-php-xml php74-php-zip php74-php-gd php74-php-mbstring php74-php-json php74-php-redis php74-php-bcmath -y
systemctl restart php74-php-fpm
ln -s /opt/remi/php74/root/usr/bin/php /usr/bin/php
php -v

# 安装 Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
# composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
