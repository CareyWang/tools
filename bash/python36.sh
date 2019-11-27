#!/bin/bash

sudo apt-get update

# 安装 python3.6
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.6 -y

# 安装 pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
