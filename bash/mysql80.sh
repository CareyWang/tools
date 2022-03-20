#!/bin/bash
# curl -fsSL https://git.io/JIRWN | bash
# https://cdn.jsdelivr.net/gh/CareyWang/tools@master/bash/mysql57.sh

# 安装 MySQL8.0
wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
dpkg -i mysql-apt-config_0.8.22-1_all.deb
apt update
apt install mysql-client mysql-server
