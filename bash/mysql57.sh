#!/bin/bash

sudo apt update

# 安装 MySQL5.7
sudo apt install -y mysql-client-5.7 mysql-server-5.7 
# ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
# ALTER USER 'root' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER;

# 安装 MySQL8.0
# wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb
# sudo dpkg -i mysql-apt-config_0.8.15-1_all.deb
# sudo apt update
# sudo apt install mysql-client mysql-server 
