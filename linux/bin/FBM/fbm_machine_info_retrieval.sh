#!/bin/bash - 
#===============================================================================
#
#          FILE:  fbm_machine_info_retrieval.sh
# 
#         USAGE:  ./fbm_machine_info_retrieval.sh 
# 
#   DESCRIPTION: some information about the machine is send to fbmlog01
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Joan Marc Riera Duocastella (), marc.riera@barcelonamedia.org
#       COMPANY: Fundació Barcelona Media
#       CREATED: 12/22/2010 11:02:31 AM CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

logger -i -s "$0 - launched"
LOGFILE=$0.log
cd /tmp
exec 1>>$LOGFILE
exec 2>>$LOGFILE
SERVERIP="xx.tt.rr.uu"
SERVERPATH="scripts"
MASTERURL=http://$SERVERIP/$SERVERPATH
## Don't edit above this line
SCRIPTNAME=$0
DATETIME=`date +%Y%m%d%H%M%S`
HNAME=`hostname`
REPOFILE=$HNAME"_"$DATETIME"_"
# load marcs library
tempscript="library.sh"
[ ! -f ./$tempscript ] && wget $MASTERURL/lib/$tempscript
. ./$tempscript && rm $tempscript
# define environment
shootProfile 

#############basic info
function basicInfo(){
echo "Hostname: $HNAME"
echo "Date: $DATETIME"
}
####################OS
function osInfo(){
	 echo "#### OS"
	 echo "OS:$OS" 
	 echo "DIST:$DIST"
	 echo "DistroBasedOn:$DistroBasedOn"
	 echo "PSUEDONAME:$PSUEDONAME"
	 echo "REV:$REV"
	 echo "KERNEL:$KERNEL"
	 echo "MACH:$MACH"
}
####################hardware
function cpuInfo(){
	echo "#### CPU"
	cat /proc/cpuinfo | grep -A7 processor | tail -8
	cat /proc/cpuinfo | grep -A1 flags | tail -2
}
function ramInfo(){
	echo "#### RAM" 
	free -m
}
function networkInfo(){
	echo "#### network"
	ip addr | grep -B2 inet | egrep -v "127.0.0.|loopback|lo:|--"
	ip route
	cat /etc/resolv.conf
}
function discInfo(){
	echo  "#### disc"
	df -PhT
	mount
	cat /proc/swaps
	fdisk -l
	cat /etc/fstab
}
function hardwareInfo(){
	cpuInfo
	ramInfo
	networkInfo
	discInfo
}
####################software
function installedInfo(){
	echo "#### Installed software"
	dpkg -l|grep -i -E "Quest|vintela|denyhosts|fail2ban"
}
function usersInfo(){
	echo "#### Privileged users"
	cat /etc/sudoers
	echo "#### Groups"
	cat /etc/group
	echo "#### Local users"
	cat /etc/passwd
	echo "#### shadow password"
	cat /etc/shadow
}
function homeInfo(){
	echo "#### home folders"
	ls /home
}
function softwareInfo(){
	installedInfo
	usersInfo
	homeInfo
}
############################################main
############################################
############################################
REPOFILEOS=$REPOFILE"os.txt"
REPOFILEHW=$REPOFILE"hw.txt"
REPOFILESW=$REPOFILE"sw.txt"
REPOFILEOTHER=$REPOFILE"other.txt"
exec 1> $REPOFILEOS
basicInfo
osInfo
exec 1> $REPOFILEHW
basicInfo
hardwareInfo
exec 1> $REPOFILESW
basicInfo
softwareInfo
#create temp dir
exec 1> $REPOFILEOTHER
[ -d /nfs ] || mkdir /nfs
#mount nfs
whoami
installPkg nfs-common
mount -o soft,intr,rsize=8192,wsize=8192 fbmlog01:/srv/reports /nfs
#move to nfs
cp $REPOFILE* /nfs/
umount /nfs
#delete originals
#rm *_$REPOFILE
exit 0
