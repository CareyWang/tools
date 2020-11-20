#!/bin/bash

sudo apt update 
sudo apt install curl socat -y && curl https://get.acme.sh | sh

# 获取ssl证书
sudo /etc/init.d/nginx stop
sudo mkdir /etc/trojan/
sudo ~/.acme.sh/acme.sh --issue -d trojan.v2cdn.gq --standalone -k ec-256
sudo ~/.acme.sh/acme.sh --installcert -d trojan.v2cdn.gq --fullchainpath /etc/trojan/trojan.crt --keypath /etc/trojan/trojan.key --ecc
chmod +r /etc/trojan/trojan.key

# 安装trojan
sudo apt install xz-utils -y
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
sudo sed -i 's/example.com/trojan.v2cdn.gq/g' ../nginx-conf/trojan.conf
sudo cp ../nginx-conf/trojan.conf /etc/nginx/sites-available/trojan
sudo ln -s /etc/nginx/sites-available/trojan /etc/nginx/sites-enabled/trojan
sudo /etc/init.d/nginx restart
