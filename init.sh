#!/bin/bash
sudo apt-get update

# 安装语言包
sudo apt-get install -y language-pack-en-base
sudo locale-gen en_US.UTF-8

# 安装常用软件
sudo apt-get install -y vim git zip unzip mutt

# 安装 php7.3
sudo apt-get install -y software-properties-common
sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.3 php7.3-fpm php7.3-mysql php7.3-curl php7.3-soap php7.3-xml php7.3-zip php7.3-gd php7.3-mbstring php7.3-json php7.3-xdebug -y

# 安装 MySQL5.7
sudo apt-get install -y mysql-server-5.7 mysql-client-5.7

# 安装 nginx
sudo service apache2 stop
sudo apt-get --purge remove apache2 -y
sudo apt-get autoremove -y
sudo apt-get install -y nginx

# 安装 jdk tomcat
sudo apt-get install openjdk-8-jdk -y
sudo apt-get install tomcat8 -y

# 安装 Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
# composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# 安装 python3
# sudo apt-get install software-properties-common
# sudo add-apt-repository ppa:deadsnakes/ppa
# sudo apt-get update
# sudo apt-get install python3.6

# command -v pip3

# 安装 nodejs
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
# npm config set registry https://registry.npm.taobao.org

# 安装 yarn
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn -y

# 宝塔
# ubuntu
# wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
# centos
# yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
# debian
# wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh

# 安装 docker-ce
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# 安装 docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# 安装 Go
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install golang-go -y
