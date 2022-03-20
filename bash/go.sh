#!/bin/bash

sudo apt update

# 安装 Go
wget https://go.dev/dl/go1.18.linux-amd64.tar.gz 
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz

# 配置 go modules 代理
# go env -w GO111MODULE="on"
# go env -w GOPROXY="https://goproxy.cn,direct"
