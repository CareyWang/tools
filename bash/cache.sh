#!/bin/bash
# https://git.io/JIRld

sudo apt update

# 安装Redis
sudo add-apt-repository ppa:chris-lea/redis-server -y
sudo apt update
sudo apt install redis-server -y
