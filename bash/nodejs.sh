#!/bin/bash
# https://raw.githubusercontent.com/CareyWang/tools/master/bash/nodejs.sh
# https://git.io/JIRle
# https://cdn.jsdelivr.net/gh/CareyWang/tools@master/bash/nodejs.sh

sudo apt update

# 安装 nodejs
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y nodejs
# npm config set registry https://registry.npm.taobao.org

# 安装 yarn
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn -y

# pm2
yarn global add pm2
pm2 set pm2:autodump true
pm2 startup
pm2 install pm2-logrotate
pm2 set pm2-logrotate:retain 5
pm2 set pm2-logrotate:max_size 5M
pm2 set pm2-logrotate:compress true
