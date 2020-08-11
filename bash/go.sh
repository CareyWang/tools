#!/bin/bash

sudo apt-get update

# 安装 Go
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt-get update
sudo apt-get install golang-go -y
# 配置 go modules 代理
# go env -w GO111MODULE="on"
# go env -w GOPROXY="https://goproxy.cn,direct"
