#!/bin/bash

sudo apt-get update

# 宝塔
# ubuntu
# wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
# centos
# yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
# debian
# wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh

# 添加 swap
sudo fallocate -l 1G /swapfile
# sudo dd if=/dev/zero of=/swapfile bs=1024 count=1048576
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
sudo swapon --show
free -m

# 安装 MinIO
docker run -d -p 9000:9000 --name minio1 --restart always \
  -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" \
  -e "MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" \
  -v /mnt/minio/data:/data \
  -v /mnt/minio/config:/root/.minio \
  minio/minio server /data
# curl -O https://raw.githubusercontent.com/minio/minio/master/docs/orchestration/docker-compose/docker-compose.yaml
# docker-compose up

# 安装mtproxy
sudo apt-get install -y psmisc
wget -O mtg --no-check-certificate https://raw.githubusercontent.com/whunt1/onekeymakemtg/master/builds/mtg-linux-amd64
sudo mv mtg /usr/local/bin/mtg
sudo chmod +x /usr/local/bin/mtg
# 生成TLS伪装密钥
# mtg generate-secret -c itunes.apple.com tls
nohup mtg run -b 0.0.0.0:443 --cloak-port=443 ee055a9b283c6ef2fbea89a374df31e7966974756e65732e6170706c652e636f6d >> /var/log/mtg.log 2>&1 &
