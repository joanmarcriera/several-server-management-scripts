#!/bin/bash -x
#===============================================================================
#
#          FILE:  fbm_logon_script_workstation.sh
# 
#         USAGE:  ./fbm_logon_script_workstation.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Joan Marc Riera Duocastella (), marc.riera@barcelonamedia.org
#       COMPANY: Fundació Barcelona Media
#       CREATED: 12/22/2010 11:07:00 AM CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

logger -i -s "$0 - launched"
#clean temp files
LOGFILE=/$0.log
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
# load marcs library
tempscript="library.sh"
if [ ! -f /tmp/$tempscript ]
then
         wget $MASTERURL/lib/$tempscript -O /tmp/$tempscript
         . /tmp/$tempscript && rm /tmp/$tempscript
fi
# define environment
shootProfile
# check if USER env variable is set, or otherwise set it
[ -n "${USER:-x}" ] && USER=`whoami` 
#check if .desktop exists else do it
if [[ -f /home/$USER/.config/user-dirs.dirs ]]
then
	desktop_dir=/home/$USER/`grep XDG_DESKTOP_DIR /home/$USER/.config/user-dirs.dirs  | cut -f2 -d\" | cut -f2 -d\/`
fi
if [[ -n "${desktop_dir:+x}" ]] && [[ ! -f "$desktop_dir/montar unitat de xarxa.desktop" ]]
then
	
	case $OS in
		 linux )	
			  tempscript="fs_fbm.tar"
			  ;;
		 mac )
			  tempscript="fs_fbm_macosx.tar"
			  ;;
		 * ) #at least try if there is luck
			  tempscript="fs_fbm.tar"
			  ;;
	esac
	
	#download fs_fbm.tar
	if [ ! -f /tmp/$tempscript ]
	then
		 wget $MASTERURL/src/$tempscript -O /tmp/$tempscript
	fi
	cd /tmp
	tar -xvf /tmp/$tempscript 
	rm  /tmp/$tempscript
	cd ${tempscript%%.???}
	datasrc_dir="`pwd`/data"
	#if [[ $CANGOSUDO -eq $TRUE ]]
	#then
	#we are not installing anything on a logonscript 
	#	sudo ./install.sh 
	#else
	cp $datasrc_dir/*.desktop $desktop_dir
	chmod +x $desktop_dir/montar*.desktop
	chmod +x $desktop_dir/desmontar*.desktop
	#fi
#	rm -r /tmp/${tempscript%%.???}
fi
#############################################fbm_mount end
##########################check sudoers
 # :TODO:12/22/2010 11:09:09 AM CET:: if uptime>15 dies mail with reboot and upgrade request
uptime
exit 0
