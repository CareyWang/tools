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

mkdir -p /etc/shadowsocks-libev
echo '{
    "server":"0.0.0.0",
    "server_port":9000,
    "method":"chacha20-ietf",
    "timeout":300,
    "password":"Passw0rd.",
    "fast_open":false,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}' > /etc/shadowsocks-libev/config.json
docker run -d -p 9000:9000 -p 9000:9000/udp --name ss-libev --restart=always -v /etc/shadowsocks-libev:/etc/shadowsocks-libev teddysun/shadowsocks-libev

docker run -d --restart always --name clash -p 7890:7890 -p 7891:7891 -v /etc/clash/clash.yaml:/root/.config/clash/config.yaml dreamacro/clash
