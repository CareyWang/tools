#!/bin/bash

sudo apt-get update

# 安装 python3.6
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install python3.6 -y

# 安装 pip
sudo apt-get install python3-distutils
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

# 安装 supervisor
# easy_install supervisor
# mkdir /etc/supervisor
# echo_supervisord_conf > /etc/supervisor/supervisord.conf
# mkdir -p /etc/supervisor/conf.d
# supervisord -c /etc/supervisor/supervisord.conf
