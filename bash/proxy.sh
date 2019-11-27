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
    "method":"chacha20",
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
