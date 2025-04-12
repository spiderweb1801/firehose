#!/bin/bash
yum update -y
amazon-linux-extras install nginx1
systemctl start nginx
systemctl enable nginx

# Fetch metadata
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

echo "Private IP: $PRIVATE_IP" > /usr/share/nginx/html/index.html
echo "Public IP: $PUBLIC_IP" >> /usr/share/nginx/html/index.html
echo "Region: $REGION" >> /usr/share/nginx/html/index.html
