#!/bin/bash

sudo apt-get update
sudo apt-get install git vim wget -y

mkdir -p /var/www/http && cd /var/www/http

wget https://raw.githubusercontent.com/CareyWang/tools/master/bash/nodejs.sh
bash nodejs.sh
yarn global add pm2 

git clone https://github.com/nondanee/UnblockNeteaseMusic.git
cd UnblockNeteaseMusic
pm2 start app.js --name netease --max-memory-restart 150M
pm2 save 
pm2 startup
