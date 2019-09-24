# System Engineer Assignment


## Challenge A: Web Server Setup for WordPress
Create a command-line script, preferably in bash, to perform following tasks in order.

1. Check if PHP, Mysql & Nginx are installed. If not present, install the missing packages
2. Ask the user for a domain name We will assume that the user enters "example.com"
3. Create a /etc/hosts entry for example.com pointing to localhost
4. Create an nginx config file for example.com
5. Download the latest WordPress version and unzip it locally in example.com document root (Hint: Use http://wordpress.org/latest.zip)
6. Create a new Mysql database for WordPress with name “example.com_db”
7. Create a wp-config.php with proper DB configuration (Hint: You can use wp-config-sample.php as your template)
8. Fix any file permissions, clean up temporary files and restart/reload Nginx config
9. Prompt the user to open example.com in a browser if all goes well.
