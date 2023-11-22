#!/bin/bash

apt update

# 设置时区
date
tzselect
cp /etc/localtime /etc/localtime.bak
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
apt install ntpdate -y
ntpdate time.windows.com

# 安装语言包
apt install -y language-pack-en-base
locale-gen en_US.UTF-8

# 安装常用软件
apt install -y vim git zip unzip software-properties-common

# 安装 nginx
service apache2 stop
apt-get autoremove -y
apt install -y nginx

# 安装certbot
# apt update
# add-apt-repository universe
# add-apt-repository ppa:certbot/certbot -y
# apt update
# apt install certbot python-certbot-nginx -y
# certbot --nginx
# certbot certonly --nginx
apt install snapd -y
snap install core; snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

# 安装 docker-ce
curl -fsSL https://get.docker.com | bash 

# 国内 docker 源
# curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | apt-key add -
# add-apt-repository \
#     "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
#     $(lsb_release -cs) \
#     stable"
# apt update
# apt install -y docker-ce docker-ce-cli containerd.io
  
# 国内镜像加速器
# mkdir -p /etc/docker
# tee /etc/docker/daemon.json <<EOF
# {
#   "registry-mirrors": [
#       "https://hub-mirror.c.163.com",
#       "https://mirror.baidubce.com"
#   ]
# }
# EOF
# systemctl daemon-reload
# systemctl restart docker

# 安装 docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
# 国内加速
# curl -L https://get.daocloud.io/docker/compose/releases/download/2.23.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose
