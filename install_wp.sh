#!/bin/bash
isPHPInstalled=$(dpkg -l | grep php | wc -l)
isMySQLInstalled=$(dpkg -l | grep mysql | wc -l)
isNginxInstalled=$(dpkg -l | grep nginx | wc -l)
numberOfInterfaces=$(ifconfig -a | grep "flags=" | grep -v lo | wc -l)

########### ASKING FOR ROOT PRIVILEGE ########### 

if [ $EUID != 0 ]; then
	    sudo "$0" "$@"
	        exit $?
	fi

########### UPDATE SYSTEM ########### 

echo "Updating the system if necessary"

apt update -y > /dev/null 2>&1
apt upgrade -y > /dev/null 2>&1
# installing zip
apt install zip -y  > /dev/null 2>&1
# cleaning up
apt autoremove -y > /dev/null 2>&1

########### CHECK IF PHP NEEDS TO BE INSTALLED AND INSTALL IF IT'S NOT PRESENT ########### 

echo "Checking if PHP needs to be installed"

if [ $isPHPInstalled -gt 0 ]; then
# php is installed
	echo "OK, PHP is already installed"
else
# php is not installed, installing it
	echo "PHP is not installed, installing it..."
	apt install php php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php7.2-fpm php-mysql -y > /dev/null 2>&1
fi

########### CHECK IF MYSQL NEED TO BE INSTALLED AND INSTALL IF IT'S NOT PRESENT ########### 

echo "Checking if MySQL needs to be installed"

if [ $isMySQLInstalled -gt 0 ]; then
# mysql is installed
	echo "OK, MySQL is already installed"
else
# mysql is not installed, installing it
	echo "MySQL is not installed, installing it..."
	apt install mysql-server -y > /dev/null 2>&1
fi

########### CHECK IF MYSQL NEED TO BE INSTALLED AND INSTALL IF IT'S NOT PRESENT ########### 

echo "Checking if Nginx needs to be installed"

if [ $isNginxInstalled -gt 0 ]; then
# nginx is installed
	echo "OK, Nginx is already installed"
else
# ngins is not installed, installing it
	echo "Nginx is not installed, installing it..."
	apt install nginx -y > /dev/null 2>&1
fi

########### ASKING FOR THE DOMAIN NAME ########### 

echo "Please enter the Domain Name"
# storing domain name in a variable
read domainName
# storing domainName_db in a variable for mysql configuration
dbName="${domainName}db"

########### CHECKING IF IP IS IN HOSTS FILE, IF NOT APPEND IT ###########

# checking how many interfaces there are, besides loopback
if [ $numberOfInterfaces -gt 1 ]; then
# if there are more then 1 (except loopback) than ask to which address it should bind it
	echo "You have multiple interfaces. Which one would you like to bind the domain to?"
	hostname -I
	read interfaceToBindTo
	echo "$interfaceToBindTo $domainName" >> /etc/hosts
else
# there is only 1 interface besides loopback, bind it to that address
	echo "$(hostname -I) $domainname" >> /etc/hosts
fi

########### NGINX CONFIG ###########

root="/var/www/$domainName/html"
block="/etc/nginx/sites-available/$domainName"

# Create the Document Root directory
sudo mkdir -p $root

# Create the Nginx server block file:
sudo tee $block > /dev/null <<EOF 
server {
        listen 81;
        root /var/www/$domainName/html/wordpress;
        index index.php index.html index.htm;
        server_name $domainName www.$domainName;

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	}
}
EOF

# Link to make it available
sudo ln -s $block /etc/nginx/sites-enabled/

########### DOWNLOADING AND EXTRACTING LATEST WORDPRESS ###########

echo "Downloading the latest wordpress"
wget --quiet http://wordpress.org/latest.zip
echo "Unzipping wordpress"
unzip latest.zip -d $root > /dev/null 2>&1 && rm -rf latest.zip

echo "Type in the user for WordPress"
read wordpressUser
echo "Type in the password for $wordpressUser"
read wordpressDBUserPassword

#creating the database for wordpress
mysql -e "create database $dbName;"
#creating the wordpressuser on the database
mysql -e "create user $wordpressUser identified by \"$wordpressDBUserPassword\";"
#granting all privileges to wordpress on the database
mysql -e "grant all on $dbName.* to $wordpressUser;"
#flushing privileges
mysql -e "flush privileges;"

#taking the wp-config-sample for configuring the connection
cp /var/www/$domainName/html/wordpress/wp-config-sample.php /var/www/$domainName/html/wordpress/wp-config.php
#changing database name connection
sed -i "s/database_name_here/$dbName/g" /var/www/$domainName/html/wordpress/wp-config.php
#changing database user connection
sed -i "s/username_here/$wordpressUser/g" /var/www/$domainName/html/wordpress/wp-config.php
#chaning database passwod connection
sed -i "s/password_here/$wordpressDBUserPassword/g" /var/www/$domainName/html/wordpress/wp-config.php

#changing ownership of files
chown www-data:www-data /var/www/$domainName
chown www-data:www-data /var/www/$domainName/* -R
chown www-data:www-data /etc/nginx
chown www-data:www-data /etc/nginx/* -R

#restarting nginx
service nginx restart

echo "Installation DONE. Visit $domainName in the browser, on port 81"
