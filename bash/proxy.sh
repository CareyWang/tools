#!/bin/bash

sudo apt update

# 安装v2-ui
bash <(curl -Ls https://blog.sprov.xyz/v2-ui.sh)

# 安装shadowsocks-r
mkdir -p /etc/shadowsocks-r
cat > /etc/shadowsocks-r/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_ipv6":"::",
    "server_port":9002,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"o2XpeePkIsqP",
    "timeout":120,
    "method":"chacha20-ietf",
    "protocol":"origin",
    "protocol_param":"",
    "obfs":"plain",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":true,
    "workers":1
}
EOF
docker run -d --network host --name ssr --restart=always -v /etc/shadowsocks-r:/etc/shadowsocks-r teddysun/shadowsocks-r

mkdir -p /etc/shadowsocks-libev
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server": "0.0.0.0",
    "server_port": 9000,
    "password": "o2XpeePkIsqP",
    "timeout": 60,
    "mode":"tcp_and_udp",
    "method": "chacha20-ietf-poly1305"
}
EOF
docker run -d -p 9000:9000 -p 9000:9000/udp --name ss-libev --restart=always -v /etc/shadowsocks-libev:/etc/shadowsocks-libev teddysun/shadowsocks-libev

mkdir -p /etc/shadowsocks-rust
cat > /etc/shadowsocks-rust/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":9000,
    "password":"Wm_1tdY2xe",
    "timeout":300,
    "method":"aes-256-gcm",
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
EOF
docker run -d -p 9001:9000 -p 9001:9000/udp --name ss-rust --restart=always -v /etc/shadowsocks-rust:/etc/shadowsocks-rust teddysun/shadowsocks-rust

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "inbounds": [{
    "port": 9000,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "6d6ab639-74f6-41ba-93cc-7f369b0ce901"
        }
      ]
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF
docker run -d -p 9002:9000 --name xray --restart=always -v /etc/xray:/etc/xray teddysun/xray

# Clash with docker
docker run -d --name clash --restart always -p 7890:7890 -v /etc/clash/config.yaml:/root/.config/clash/config.yaml dreamacro/clash

# trojan-go
sudo apt install unzip -y
mkdir /etc/trojan-go && cd /etc/trojan-go
wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.8.2/trojan-go-linux-amd64.zip && unzip trojan-go-linux-amd64.zip
certbot certonly --preferred-challenges dns --manual -d *.ttgg.me --server https://acme-v02.api.letsencrypt.org/directory
cp /etc/letsencrypt/live/ttgg.me/fullchain.pem ./server.crt
cp /etc/letsencrypt/live/ttgg.me/privkey.pem ./server.key
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
        "1.1.1.1"
    ],
    "ssl": {
        "cert": "server.crt",
        "key": "server.key",
        "sni": "rn.ttgg.me"
    },
    "mux" :{
        "enabled": true
    }
}
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
pm2 start gost --name gost-relay --max-memory-restart 100M -- -L relay+mwss://:19001/127.0.0.1:9001

客户端: gost -L tcp://:65535 -F relay+mwss://{$remote_addr}:65535
pm2 start gost --name gost-relay-racknerd --max-memory-restart 100M -- -L tcp://:19001 -F relay+mwss://173.82.250.143:19001

wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh
./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
