#!/bin/bash

sudo apt update

# 安装 Go
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update
sudo apt install golang-go -y
# 配置 go modules 代理
# go env -w GO111MODULE="on"
# go env -w GOPROXY="https://goproxy.cn,direct"
