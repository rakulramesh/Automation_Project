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

if [ -e /var/www/html/inventory.html ]
then
	echo "Inventory html exists"
else
	echo "Log Type &ensp;&ensp; Date Created &ensp;&ensp; Type &ensp;&ensp; Size" >> /var/www/html/inventory.html
fi
size=$(sudo du -h /tmp/${myname}-httpd-logs-${timestamp}.tar | awk '{print $1}')
echo "<br>httpd-logs &ensp;&ensp; ${timestamp} &ensp;&ensp; tar &ensp;&ensp; ${size} &ensp;&ensp; </br>" >> /var/www/html/inventory.html


if [ -e /etc/cron.d/automation ]
then
	echo "Cron job exists already"
else
	echo "Adding cronjob"
	echo "0 0 * * * root sudo sh /root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi
