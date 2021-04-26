#!/bin/bash 

yum makecache 
yum install vim git curl wget unzip -y 

yum install -y -q yum-utils

curl -fsSL https://get.docker.com | bash 
systemctl start docker
systemctl enable docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose -v
