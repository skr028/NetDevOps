#!/bin/bash
sudo yum install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
echo 'Started Apache from Terraform' > /var/www/html/index.html
