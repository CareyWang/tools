#!/bin/bash 

yum install nginx -y
systemctl start nginx
systemctl enable nginx

yum install snapd -y
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
