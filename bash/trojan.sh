#!/bin/bash

sudo apt-get update 
sudo apt-get install curl socat -y && curl https://get.acme.sh | sh

# 获取ssl证书
sudo mkdir /etc/trojan/
sudo ~/.acme.sh/acme.sh --issue -d trojan.v2cdn.gq --standalone -k ec-256
sudo ~/.acme.sh/acme.sh --installcert -d trojan.v2cdn.gq --fullchainpath /etc/trojan/trojan.crt --keypath /etc/trojan/trojan.key --ecc
chmod +r /etc/trojan/trojan.key

# 安装trojan
sudo apt-get install xz-utils -y
sudo bash -c "$(wget -O- https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
sed  -i 's/path/etc/g' /usr/local/etc/trojan/config.json
sed  -i 's/to/trojan/g' /usr/local/etc/trojan/config.json
sed  -i 's/certificate.crt/trojan.crt/g' /usr/local/etc/trojan/config.json
sed  -i 's/private.key/trojan.key/g' /usr/local/etc/trojan/config.json
sed  -i 's/password1/Passw0rd/g' /usr/local/etc/trojan/config.json
sed  -i 's/password2/Passw0rd/g' /usr/local/etc/trojan/config.json
cat /usr/local/etc/trojan/config.json

sudo systemctl enable trojan
sudo systemctl start trojan
# 查看log
# journalctl -e -u trojan.service

# 开启BBR
sudo echo "net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
sudo echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sudo sysctl -p

# nginx配置
server {
    listen 127.0.0.1:80; #放在Trojan后面即可做伪装也可以是真正的网站
    server_name trojan.v2cdn.gq;
    location / {
        root /usr/share/nginx/html/; #默认的根目录
        index index.html; #默认的html文件
    }
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always; #HSTS标头
}

server {
    listen 80;
    listen [::]:80;
    server_name trojan.v2cdn.gq;
    return 301 https://trojan.v2cdn.gq; #301 https重定向
}
