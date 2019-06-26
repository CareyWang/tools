#!/usr/bin/env bash
sudo apt-get update

# 安装语言包
sudo apt-get install -y language-pack-en-base
sudo locale-gen en_US.UTF-8

# 安装常用软件
sudo apt-get install -y vim git zip unzip mutt

# 安装 PHP7.2
sudo apt-get install -y software-properties-common
# sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get install -y php7.2 php7.2-fpm php7.2-mysql php7.2-curl php7.2-soap php7.2-xml php7.2-zip php7.2-gd php7.2-mbstring php7.2-json php7.2-xdebug -y

# 安装 Mysql
apt-get install mysql-server-5.7 mysql-client-5.7

# 安装 Nginx
sudo service apache2 stop
sudo apt-get --purge remove apache2
sudo apt-get --purge remove apache2.2-common
sudo apt-get autoremove
sudo rm -rf /etc/libapache2-mod-jk

sudo apt-get install -y nginx

# 安装 jdk tomcat
sudo apt-get install php-imagick -y
sudo apt-get install openjdk-8-jdk -y
sudo apt-get install tomcat8 -y
sudo apt-get install mailutils imagemagick graphicsmagick zip python python-mysqldb phantomjs python-pexpect wkhtmltopdf xvfb -y

# 安装 composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# 安装 python3
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.6

command -v pip3

# 安装 nodejs
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

# 宝塔
wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh

