#!/bin/bash
# ssh fail2ban

sudo apt update

sudo apt install fail2ban -y
sudo cp ../fail2ban.local /etc/fail2ban/jail.local
sudo /etc/init.d/fail2ban restart
