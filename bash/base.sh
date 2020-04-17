#!/bin/bash

sudo apt-get update

# 安装语言包
sudo apt-get install -y language-pack-en-base
sudo locale-gen en_US.UTF-8

# 安装常用软件
sudo apt-get install -y vim git zip unzip software-properties-common

# 安装 nginx
sudo service apache2 stop
sudo apt-get autoremove -y
sudo apt-get install -y nginx

# 安装certbot
sudo apt-get update
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx -y
# sudo certbot --nginx
# sudo certbot certonly --nginx

# 安装 docker-ce
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# 国内 docker 源
# curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository \
#     "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
#     $(lsb_release -cs) \
#     stable"
#     
# 国内镜像加速器
# sudo mkdir -p /etc/docker
# sudo tee /etc/docker/daemon.json <<-'EOF'
# {
#   "registry-mirrors": ["https://hub-mirror.c.163.com"]
# }
# EOF
# sudo systemctl daemon-reload
# sudo systemctl restart docker

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# 安装 docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
# 国内加速
# curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose