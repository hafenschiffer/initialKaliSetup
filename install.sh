#!/bin/sh
#Prepare
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
mkdir /root/tools

#Install tools
apt-get install ftp -y
apt-get install pure-ftpd -y
apt-get install terminator -y
apt-get install golang -y
apt-get install openvas -y
apt-get install gobuster -y
apt-get install bridge-utils -y

#Git Respounder
cd /root/tools
git clone https://github.com/maurosoria/dirsearch
git clone https://github.com/codeexpress/respounder
cd /root/tools/respounder
go build respounder.go

#Setup ftp server
groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc ftpuser
pure-pw useradd user -u ftpuser -d /ftphome
pure-pw mkdb #pw will be chosen while running script
cd /etc/pure-ftpd/auth/
ln -s ../conf/PureDB 60pdb
mkdir -p /ftphome
chown -R ftpuser:ftpgroup /ftphome/
/etc/init.d/pure-ftpd restart

#Enable services
systemctl enable apache2
systemctl enable postgresql

#populate some files
mkdir /var/www/html/linux
mkdir /var/www/html/win
cd /var/www/html/linux
wget https://raw.githubusercontent.com/sleventyeleven/linuxprivchecker/master/linuxprivchecker.py
wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
wget https://highon.coffee/downloads/linux-local-enum.sh
chmod +x LinEnum.sh
chmod +x linuxprivchecker.py
chmod +x linux-local-enum.sh
cp -r /var/www/html/* /ftphome/

#MSF DB initialization
msfdb init

#unzip rockyou
gunzip /usr/share/wordlists/rockyou.txt.gz

#Clean up
apt-get autoremove -y
apt-get autoclean
