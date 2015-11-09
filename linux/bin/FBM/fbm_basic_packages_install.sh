#!/bin/sh
# Variables
SERVERIP="xx.tt.rr.uu"
SERVERPATH="scripts"
MASTERURL=http://$SERVERIP/$SERVERPATH

## Don't edit above this line
SCRIPTNAME=$0
DATETIME=`date +%Y%m%d%H%M%S`
#
# load marcs library
[ ! -f ./library.sh ] && wget $MASTERURL/lib/library.sh 
. ./library.sh
###########################################
# define environment
shootProfile 
#TODO  #### add the repos to feach all programs.
mv /etc/apt/sources.list{,.install_bak}
wget $MASTERURL/etc/apt/sources.list -O /etc/apt/sources.list

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9A6FE242
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4E5E17B5
wget -q https://dl-ssl.google.com/linux/linux_signing_key.pub -O- | apt-key add -
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1F196A8
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1BD3A65C
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40130828

apt-get clean
apt-get update
#apt-get -y install htop vim snmp snmpd lm-sensors build-essential linux-headers-`uname -r` psmisc openssh-server
installPkg htop vim snmp snmpd lm-sensors build-essential linux-headers-`uname -r` psmisc openssh-server sysstat mtr nmap nfs-common terminator pidgin virtualbox opera vlc chromium-browser thunderbird
apt-get -y remove gnome-games-common gbrainy
apt-get autoremove
return 0
