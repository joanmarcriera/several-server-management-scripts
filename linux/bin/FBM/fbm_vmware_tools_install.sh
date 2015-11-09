#!/bin/bash
#TODO 
# falta fer la comprovació de la paqueteria psmisc headers i buildessential
# usar library::installPkg 
# check if vmware tools cd is mounted by script

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

apt-get clean
apt-get update
#apt-get -y install htop vim snmp snmpd lm-sensors build-essential linux-headers-`uname -r` psmisc openssh-server
installPkg htop vim snmp snmpd lm-sensors build-essential linux-headers-`uname -r` psmisc openssh-server sysstat gcc



echo "Assegurar-se que hi ha les vmware tools posades.[press intro]"
read x
mkdir -p /media/cdrom
mount /dev/cdrom /media/cdrom
VMWPACK=`ls /media/cdrom/VM* |cut -d/ -f4`
cp /media/cdrom/$VMWPACK /root
cd /root
tar xvzf /root/$VMWPACK
rm $VMWPACK
cd vmware-tools-distrib/
./vmware-install.pl -d
ifconfig eth0 down
ifconfig eth0 up
/etc/init.d/networking restart
return 0
