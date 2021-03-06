#!/bin/bash

sudo apt update

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
sudo apt install -y psmisc
wget -O mtg --no-check-certificate https://raw.githubusercontent.com/whunt1/onekeymakemtg/master/builds/mtg-linux-amd64
sudo mv mtg /usr/local/bin/mtg
sudo chmod +x /usr/local/bin/mtg
# 生成TLS伪装密钥
# mtg generate-secret -c itunes.apple.com tls
sudo nohup mtg run -b 0.0.0.0:443 --cloak-port=443 ee055a9b283c6ef2fbea89a374df31e7966974756e65732e6170706c652e636f6d >> /var/log/mtg.log 2>&1 &
pm2 start mtg --name mtp --max-memory-restart 200M -- run -b 0.0.0.0:543 --cloak-port=543 ee0b4d2179faf1fb64f46e1c8a33beedc67777772e6f66666963652e636f6d
# www.bing.com
# ee4da25d7079c9f8f38c1512b436ec45e37777772e62696e672e636f6d
# docker
docker run -d \
 --name=mtp \
 --restart=always \
 -p 543:443 \
 -e "MTG_BIND=0.0.0.0:443" \
 -e "MTG_CLOAK_PORT=443" \
 nineseconds/mtg run ee65989d8136d7cb56ca3b7e965e5a56596974756e65732e6170706c652e636f6d

# www.office.com
docker run -d \
 --name=mtp \
 --restart=always \
 -p 543:443 \
 -e "MTG_BIND=0.0.0.0:443" \
 -e "MTG_CLOAK_PORT=443" \
 nineseconds/mtg run eeca94746dddf4cc279bad313df1329baf7777772e6f66666963652e636f6d

# PlusMedia itunes.apple.com
docker run -d \
 --name=mtp \
 --restart=always \
 -p 543:443 \
 -e "MTG_BIND=0.0.0.0:443" \
 -e "MTG_CLOAK_PORT=443" \
 nineseconds/mtg run ee58f3fe48417280490b16d536415f5a856974756e65732e6170706c652e636f6d

# gost mtp
mkdir -p /opt/gost
wget https://github.com/ginuerzh/gost/releases/download/v2.11.1/gost-linux-amd64-2.11.1.gz -O gost.gz && gzip gost.gz -d && chmod +x ./gost && mv gost /usr/local/bin/gost
echo "95.161.64.0/20 91.108.8.0/22 91.108.56.0/22 91.108.4.0/22 91.108.12.0/22 149.154.172.0/22 149.154.164.0/22 149.154.160.0/22 2001:67c:4e8::/48 2001:b28:f23d::/48" > /opt/gost/telegram.list
gost -V
nohup gost -L=socks5://china:no.1@:8999?bypass=/opt/gost/telegram.list > /var/log/gost.mtp.log 2>&1 &
pm2 start gost --name gost-mtp --max-memory-restart 100M -- -L=socks5://xianyucloud:MxxIsBest@:4396?bypass=/opt/gost/telegram.list

# gost ss
gost -L=ss://rc4-md5:ckn4bLSXHQ@:58080 -F=127.0.0.1:8080

# docker mtp 
mkdir /etc/clash 
cat > /etc/clash/config.yaml <<EOF
mixed-port: 7890
socks-port: 7891
allow-lan: true
mode: Rule
log-level: error
authentication:
 - "plusmedia:lyPp35JcGxVmronQ"

rules:
  - DOMAIN-SUFFIX,t.me,DIRECT
  - DOMAIN-SUFFIX,tdesktop.com,DIRECT
  - DOMAIN-SUFFIX,telegra.ph,DIRECT
  - DOMAIN-SUFFIX,telesco.pe,DIRECT
  - IP-CIDR,91.108.4.0/22,DIRECT,no-resolve
  - IP-CIDR,91.108.8.0/22,DIRECT,no-resolve
  - IP-CIDR,91.108.12.0/22,DIRECT,no-resolve
  - IP-CIDR,91.108.16.0/22,DIRECT,no-resolve
  - IP-CIDR,91.108.56.0/22,DIRECT,no-resolve
  - IP-CIDR,149.154.160.0/20,DIRECT,no-resolve
  - IP-CIDR6,2001:b28:f23d::/48,DIRECT,no-resolve
  - IP-CIDR6,2001:b28:f23f::/48,DIRECT,no-resolve
  - IP-CIDR6,2001:67c:4e8::/48,DIRECT,no-resolve
  - MATCH,REJECT
EOF

docker run -d --name clash --restart always -p 4396:7891 -v /etc/clash/config.yaml:/root/.config/clash/config.yaml dreamacro/clash

# rclone
curl https://rclone.org/install.sh | sudo bash
rclone config

rclone mount pr: /mnt/gd/pr --allow-other --allow-non-empty --vfs-cache-mode writes &
rclone mount ab: /mnt/gd/ab --allow-other --allow-non-empty --vfs-cache-mode writes &
rclone mount ucla: /mnt/gd/ucla --allow-other --allow-non-empty --vfs-cache-mode writes &
# fusermount -qzu /mnt/gd/pr

rclone mkdir ucla:folder1
rclone copy -v ab:folder2 ucla:folder1 --drive-server-side-across-configs

# gclone
bash <(wget -qO- https://git.io/gclone.sh)

# 网易云音乐解锁
docker run -d -p 8080:8080 --name unlocknetease nondanee/unblockneteasemusic

# 一键 DD Ubuntu1804
# https://moeclub.org/2018/04/03/603/
#
# 萌咖
# 默认账户密码: root@MoeClub.org
# sudo apt update
# sudo apt install -y xz-utils openssl gawk file -y
# bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -u 18.04 -v 64 -a
# bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -u 18.04 -v 64 -a --ip-addr 10.0.2.4 --ip-mask 255.255.255.0 --ip-gate 10.0.2.1 --mirror 'http://archive.ubuntu.com/ubuntu'
#
# 优化版，默认密码 Pwd@Linux
# http://releases.ubuntu.com/18.04.4/ubuntu-18.04.4-live-server-amd64.iso
wget --no-check-certificate -O AutoReinstall.sh https://git.io/AutoReinstall.sh && bash AutoReinstall.sh

sudo apt update
sudo apt install -y xz-utils openssl gawk file
wget --no-check-certificate https://shell.p1e.cn/reinstall/Network-Reinstall-System-Modify.sh && chmod a+x Network-Reinstall-System-Modify.sh
bash Network-Reinstall-System-Modify.sh -Ubuntu_18.04
# 默认root密码: cxthhhhh.com

# brook 流量转发
wget https://github.com/txthinking/brook/releases/download/v20200909/brook_linux_amd64 -O /usr/local/bin/brook && chmod +x /usr/local/bin/brook
brook relay -f :9001 -t hk-1.node.xianyucloud.xyz:777
pm2 start brook --name ss-linode-jp-1 -- relay -f :9002 -t jp-1.linode.xianyucloud.xyz:9001
pm2 start brook --name t-linode-jp-1 -- relay -f :1443 -t jp-1.linode.xianyucloud.xyz:443


# besttrace
mkdir besttrace && wget https://cdn.ipip.net/17mon/besttrace4linux.zip -O besttrace/besttrace4linux.zip && cd besttrace && unzip besttrace4linux.zip

# iptables 管理
sudo apt install iptables-persistent netfilter-persistent -y

# global ssh
ucloud gssh location
ucloud gssh create --location $Location --target-ip $EIP --port $Port
ucloud gssh create --location HongKong --target-ip 34.80.226.174 --port 22

# docker image update
docker run -d --restart always \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower

# 泛域名证书
certbot certonly --preferred-challenges dns --manual  -d *.example.com --server https://acme-v02.api.letsencrypt.org/directory

# 探针
# https://github.com/CokeMine/ServerStatus-Hotaru
# /usr/local/ServerStatus
wget https://raw.githubusercontent.com/CokeMine/ServerStatus-Hotaru/master/status.sh
wget https://cdn.jsdelivr.net/gh/CokeMine/ServerStatus-Hotaru@master/status.sh
#服务端
bash status.sh s
#客户端
bash status.sh c

docker run -d -p 30000:80 ilemonrain/html5-speedtest:latest

# smartdns
wget https://github.com/pymumu/smartdns/releases/download/Release33/smartdns.1.2020.09.08-2235.x86_64-debian-all.deb
apt install resolvconf -y
echo "nameserver 127.0.0.1" >>/etc/resolvconf/resolv.conf.d/head
systemctl stop systemd-resolved
/etc/init.d/resolvconf restart

# ssh proxy
ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:7890 %h %p" username@host

# docker gost
docker run -d --restart always --network host --name gost-server-emby ginuerzh/gost -L relay+mwss://:18096/127.0.0.1:8096

docker run -d --restart always --network host --name gost-client-emby ginuerzh/gost -L relay+mwss://:18096/{host}:18096

# apt proxy 
sudo touch /etc/apt/apt.conf.d/proxy.conf
sudo tee /etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire {
    HTTP::proxy "http://127.0.0.1:7890";
    HTTPS::proxy "http://127.0.0.1:7890";
}
EOF
