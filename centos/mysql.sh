#!/bin/bash 

wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm -O mysql80.rpm 
yum localinstall mysql80.rpm 
yum makecache
yum repolist all | grep mysql

sudo yum module disable mysql
sudo yum install mysql-community-server
sudo service mysqld start

sudo grep 'temporary password' /var/log/mysqld.log
# mysql -uroot -p
# ALTER USER 'root'@'localhost' IDENTIFIED BY 'G21w17lo127#bDaWcZ1H';

# docker mysql
# mkdir -p /mnt/container/mysql
# docker run -p 53306:3306 --restart always -d --name mysql57 \
# -v /mnt/container/mysql/conf:/etc/mysql/conf.d \
# -v /mnt/container/mysql/logs:/var/log/mysql \
# -v /mnt/container/mysql/data:/var/lib/mysql \
# -e MYSQL_ROOT_PASSWORD=123456 \
# mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
