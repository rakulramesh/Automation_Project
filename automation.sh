#!/bin/bash
myname="rakul"
s3_bucket="upgrad-rakul/logs"
sudo apt update -y
sudo dpkg -s apache2
if [ $(echo $?) -eq 0 ]
then 
	echo "Apache is installed"
else
	echo "Installing Apache"
	sudo apt install apache2 -y
fi

if [ $(sudo systemctl status apache2 | grep running | wc -l) -eq 1 ]
then
	echo "Apache is running"
else
	echo "Running Apache"
	sudo systemctl start apache2
fi

if [ $(sudo systemctl status apache2 | grep running | wc -l) -eq 1 ]
then
	echo "Apache is enabled"
else
	echo "Enabling Apache"
	sudo systemctl enable apache2
fi

timestamp=$(date '+%d%m%Y-%H%M%S')
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar


