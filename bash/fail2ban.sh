#!/bin/bash
# ssh fail2ban

sudo apt-get update

sudo apt-get install fail2ban -y
sudo cp ../fail2ban.local /etc/fail2ban/jail.local
sudo /etc/init.d/fail2ban restart
