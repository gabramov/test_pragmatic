#!/bin/bash
yum -y update
sudo amazon-linux-extras install nginx1 -y
sudo yum install git -y
sudo yum install jq -y
git clone https://github.com/gabramov/nginx_file
cp nginx_file/default.conf /etc/nginx/conf.d/default.conf
cp nginx_file/amazon.sh /usr/local/bin/amazon.sh
chmod 755 /usr/local/bin/amazon.sh

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /usr/share/nginx/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">Build by Power of Terraform <font color="red"> v0.12</font></h2><br><p>
<font color="green">Server PrivateIP: <font color="aqua">$myip<br><br>
<font color="magenta">
<b>Version 1.0</b>
</body>
</html>
EOF

/usr/local/bin/amazon.sh
sudo service nginx restart
