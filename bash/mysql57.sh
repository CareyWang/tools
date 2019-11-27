#!/bin/bash

sudo apt-get update

# 安装 MySQL5.7
sudo apt-get install -y mysql-client-5.7 mysql-server-5.7 
# ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
# ALTER USER 'root' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER;