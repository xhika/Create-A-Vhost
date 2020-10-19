# Create-A-Vhost!
Simple script that will download installation and run configurations for a virtual host on Ubuntu.


## Instructions
Start of with adding a new A record for the host at your host provider.
SSH into your server (ubuntu)
 
Tested on Ubuntu 20.04, Digital Ocean (Droplet) & AWS (Ec2)



```bash
git clone https://github.com/xhika/Create-A-Vhost.git
```

### Terminal
```bash
cd into folder

!! Before running the script make sure to 
edit the NGINX_HOST value to your desired host name !!

chmod +w+r+x install.sh
chmod +w+r+x config.sh

sudo ./install.sh
```

### Multiple Virtual Hosts
If multiple host wants to be created, don't forget to change the NGINX_HOST variable's value in .env file for a new Virtual Host to be created and then run
 
```sudo ./config```


## AWS (EC2)
For this script to work on AWS EC2 instance follow these steps:
```
1. Enter EC2 dashboard -> Instances 
2. Click on your newly created instance and a window will open below.
3. Click Security tab, then inder Security group click on link 
4. Edit inbound rules and add rules for http & https 
select source to be 0.0.0.0/0 
as the first ssh is on default.
5. Save rules!
```
## Digital Ocean (Droplet)
```
Just SSH into your droplet and follow the steps in this readme.
```


## Troubleshooting
- If any troubles occur, make sure ports 80 & 443 are available.
- If certbot fails, make sure envsubst have replaced variables correctly check in /etc/nginx/sites-enabled/{your_host_name}



