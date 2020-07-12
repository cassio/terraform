#!/bin/sh
yum install -y httpd
service httpd start
chkconfig httpd on

echo "Hello darkness my old friend" > /var/www/html/index.html
