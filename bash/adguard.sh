#!/bin/bash

wget https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz
tar xvf AdGuardHome_linux_amd64.tar.gz
mv AdGuardHome /etc/AdGuardHome && cd /etc/AdGuardHome

tee > /etc/systemd/system/AdGuard.service <<EOF
[Unit]
Description=AdGuard Home
After=network.target
Wants=network.target
[Service]
User=root
Group=root
WorkingDirectory=/etc/AdGuardHome
# 此处指定配置文件和工作目录
ExecStart=/etc/AdGuardHome/AdGuardHome -c /etc/AdGuardHome/AdGuardHome.yaml -w /etc/AdGuardHome -p 3000
Restart=on-failure
RestartSec=30s
LimitCORE=infinity
LimitNOFILE=1000000
LimitNPROC=1000000
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start AdGuard 

# http://127.0.0.1:3000
# 配置面板端口为 3000， https 端口为 2345
# 
# 广告拦截列表
# https://easylist-downloads.adblockplus.org/easylistchina.txt
# https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-easylist.txt
# 
# 证书路径
# /etc/letsencrypt/live/doh.example.com/fullchain.pem
# /etc/letsencrypt/live/doh.example.com/privkey.pem

# 配置反代
sudo apt install vim nginx -y

echo 'server {
    listen 80;
    # listen 443 ssl http2;
    server_name dns.example.com;

    # Add Alt-Svc header to negotiate HTTP/3.
    add_header alt-svc 'h3-27=":443"; ma=86400, h3-25=":443"; ma=86400, h3-24=":443"; ma=86400, h3-23=":443"; ma=86400';
    
    location / {
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:3000; # 此处为程序运行时指定的端口
    }
 
    location ~ .*.(gif|jpg|jpeg|png|bmp|swf|css|js)$ {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host  $host;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
 
    location /dns-query { # 这里的 Path 可以是任意
        proxy_http_version 1.1;
        proxy_set_header Host $http_host;
        proxy_buffering off;
        proxy_redirect off;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	    # 此处为 https 而不是 http; 端口为上述填写的 HTTPS 端口
        proxy_pass https://dns.example.com:2345/dns-query; # 这里的 Path 必须为 dns-query
    }
}
' > /etc/nginx/sites-available/doh

ln -s /etc/nginx/sites-available/doh /etc/nginx/sites-enabled/doh
nginx -t 
nginx -s reload 

# 安装certbot
sudo apt update
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt update
sudo apt install certbot python-certbot-nginx -y
certbot --nginx 
