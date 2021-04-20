#!/bin/bash

sudo apt update

# 安装 python3.6
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.9 -y

# 安装 pip
sudo apt install python3.9-distutils
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

# 安装 supervisor
# easy_install supervisor
# mkdir /etc/supervisor
# echo_supervisord_conf > /etc/supervisor/supervisord.conf
# mkdir -p /etc/supervisor/conf.d
# supervisord -c /etc/supervisor/supervisord.conf
