#!/bin/bash 

sudo yum install redis -y 
systemctl start redis
systemctl enable redis
