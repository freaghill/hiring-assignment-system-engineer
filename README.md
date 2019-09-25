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


### Assumptions that I have made
Thoght this was a great assignment though I haven't installed WordPress in the past. I've had some struggles setting up the environment. I've developed and tested it on the newest Ubuntu Server, in Virtualbox.

I have setup a Virtual Machine with two Network Adaptors:
1. NAT - virtio-net
2. Bridge

### The libraries I have used
I had to include in the script the installation of unzip. Wordpress required php modules.

### Instructions

I tried to comment as much as I can in the code, so it should be understandable.
This was my setup:
* Oracle VM Virtualbox
* 2 Network Cards: Nat (virtio-net), Bridge
* Newest Ubuntu Server Image
  
This is how you can use it:
  1. Clone the repo
  2. You should now see the install_wp.sh file. If you execute it, it will then run for a bit, and then starts to ask you for the configuration of the LEMP stack. Follow them along.
  3. Hopefully all went well. Open the browser and visit the site, on the port "81".
  
  
If you have any problems with this script, please don't hesitate to let me know.
If you have any questions, ask away.
