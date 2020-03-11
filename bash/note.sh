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
sudo nohup mtg run -b 0.0.0.0:443 --cloak-port=443 ee055a9b283c6ef2fbea89a374df31e7966974756e65732e6170706c652e636f6d >> /var/log/mtg.log 2>&1 &
# docker
docker run -d \
 --name=mtp \
 --restart=always \
 -p 543:443 \
 -e "MTG_BIND=0.0.0.0:443" \
 -e "MTG_CLOAK_PORT=443" \
 nineseconds/mtg  run ee65989d8136d7cb56ca3b7e965e5a56596974756e65732e6170706c652e636f6d

# rclone 
curl https://rclone.org/install.sh | sudo bash
rclone config

rclone mount pr: /mnt/gd/pr --allow-other --allow-non-empty --vfs-cache-mode writes &
rclone mount ab: /mnt/gd/ab --allow-other --allow-non-empty --vfs-cache-mode writes &
rclone mount ucla: /mnt/gd/ucla --allow-other --allow-non-empty --vfs-cache-mode writes &
# fusermount -qzu /mnt/gd/pr

rclone mkdir ucla:folder1
rclone copy -v ab:folder2 ucla:folder1 --drive-server-side-across-configs

# 网易云音乐解锁
docker run -d -p 8080:8080 --name unlocknetease nondanee/unblockneteasemusic

# 一键 DD Ubuntu1804
# https://moeclub.org/2018/04/03/603/
sudo apt-get update
sudo apt-get install -y xz-utils openssl gawk file -y
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -u 18.04 -v 64 -a


sudo apt-get update
sudo apt-get install -y xz-utils openssl gawk file
wget --no-check-certificate https://shell.p1e.cn/reinstall/Network-Reinstall-System-Modify.sh && chmod a+x Network-Reinstall-System-Modify.sh
bash Network-Reinstall-System-Modify.sh -Ubuntu_18.04
# 默认root密码: cxthhhhh.com

# brook 流量转发
wget https://github.com/txthinking/brook/releases/download/v20200201/brook -O /usr/local/bin/brook && chmod +x /usr/local/bin/brook
brook relay -l :543 -r 3.112.34.251:543
