#!/bin/bash

sudo apt-get update

# 安装v2-ui
bash <(curl -Ls https://blog.sprov.xyz/v2-ui.sh)

# 安装shadowsocks-r
mkdir -p /etc/shadowsocks-r
echo '{
    "server":"0.0.0.0",
    "server_ipv6":"::",
    "server_port":10000,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"passw0rd",
    "timeout":120,
    "method":"aes-256-gcm",
    "protocol":"auth_aes128_md5",
    "protocol_param":"2054:P5sbRB",
    "obfs":"tls1.2_ticket_auth",
    "obfs_param":"itunes.apple.com/cn/app/2054",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":true,
    "workers":1
}' > /etc/shadowsocks-r/config.json
docker run -d -p 10000:10000 -p 10000:10000/udp --name ssr --restart=always -v /etc/shadowsocks-r:/etc/shadowsocks-r teddysun/shadowsocks-r

mkdir -p /etc/shadowsocks-libev
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server": "0.0.0.0",
    "server_port": 9000,
    "password": "o2XpeePkIsqP",
    "timeout": 60,
    "mode":"tcp_and_udp",
    "method": "rc4-md5"
}
EOF
docker run -d -p 9000:9000 -p 9000:9000/udp --name ss-libev --restart=always -v /etc/shadowsocks-libev:/etc/shadowsocks-libev teddysun/shadowsocks-libev

# Clash with docker
docker run -d --name clash --restart always -p 7890:7890 -p 7891:7891 -v /var/www/http/clash/config.yaml:/root/.config/clash/config.yaml dreamacro/clash

# trojan-go
sudo apt-get install unzip -y
mkdir /etc/trojan-go && cd /etc/trojan-go 
wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.7.4/trojan-go-linux-amd64.zip && unzip trojan-go-linux-amd64.zip
certbot certonly --preferred-challenges dns --manual  -d *.example.com --server https://acme-v02.api.letsencrypt.org/directory
cp /etc/letsencrypt/live/example.com/fullchain.pem ./server.crt
cp /etc/letsencrypt/live/example.com/privkey.pem ./server.key
tee > config.json <<EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "bing.com",
    "remote_port": 80,
    "password": [
        "ChinaNo.1"
    ],
    "dns": [
        "dot://1.1.1.1",
        "dot://dns.google",
        "1.1.1.1",
        "8.8.8.8"
    ],
    "ssl": {
        "cert": "server.crt",
        "key": "server.key",
        "sni": "tr.example.com"
    }}
EOF
tee > /etc/systemd/system/trojan.service <<EOF
[Unit]
Description=trojan
AssertPathIsDirectory=LocalFolder
After=network-online.target

[Service]
Type=simple
WorkingDirectory=/etc/trojan-go/
ExecStart=/etc/trojan-go/trojan-go -config /etc/trojan-go/config.json
Restart=on-abort
User=root

[Install]
WantedBy=default.target
EOF
systemctl daemon-reload
systemctl start trojan
systemctl enable trojan

# gost隧道中转
服务端: gost -L relay+mwss://:65535/127.0.0.1:8080
客户端: gost -L tcp://:65535 -F relay+mwss://{$remote_addr}:65535
