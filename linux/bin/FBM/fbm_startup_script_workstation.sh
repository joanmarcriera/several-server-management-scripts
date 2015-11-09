#!/bin/bash -x
#===============================================================================
#
#          FILE:  fbm_startup_script_workstation.sh
# 
#         USAGE:  ./fbm_startup_script_workstation.sh 
# 
#   DESCRIPTION:  startup script for workstations, will be called from QAS GPO.
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Joan Marc Riera Duocastella (), marc.riera@barcelonamedia.org
#       COMPANY: Fundació Barcelona Media
#       CREATED: 12/22/2010 11:28:49 AM CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

#logger
#clean temp files
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
# load marcs library
tempscript="library.sh"
if [ ! -f /tmp/$tempscript ]
then
         wget $MASTERURL/lib/$tempscript -O /tmp/$tempscript
         . /tmp/$tempscript && rm /tmp/$tempscript
fi
# define environment
shootProfile

downloadAndExec "fbm_machine_info_retrieval.sh"

# :TODO:12/23/2010 01:21:10 PM CET:: install fbm_fbm
#check root password -> md5 hash compare
#check security updates - > configure auto? only servers?
#check openssh-server installed
#check fail2ban or denyhosts installed configured and updaterc.d
#download rsa key.
#create report file and send it to $fbmlog , use fbm_info_machine retrieval

# check if user can run sudo . 
# :TODO:12/23/2010 05:32:42 PM CET:: we are root because this is the startup script
CANGOSUDO=$TRUE
#[ -n "${USER:-x}" ] && USER=`whoami`
#CANGOSUDO=$FALSE
#cat /etc/group |grep -E "admin:|sudo:"|grep -E $USER
#[[ $? -eq 0 ]] && CANGOSUDO=$TRUE || CANGOSUDO=$FALSE

############################################# if not installed the 
if [[ ! -f /usr/local/bin/montar_fs_fbm.sh ]] 
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
	if [[ $CANGOSUDO -eq $TRUE ]]
	then
	        #sudo ./install.sh  #somos root
		bin_dir="/usr/local/bin"
		datasrc_dir="`pwd`/data"
		cp $datasrc_dir/*.sh $bin_dir
		chmod +x $bin_dir/*.sh
		cp $datasrc_dir/umount_fbm.sh /etc/init.d/
        	update-rc.d umount_fbm.sh defaults
	#else
		#this is a startup script, there is no such desktop for root  // this should go to logon script
	        #if [[ -f /home/$USER/.config/user-dirs.dirs ]]
	        #then
	        #        desktop_dir=/home/$USER/`grep XDG_DESKTOP_DIR /home/$USER/.config/user-dirs.dirs  | cut -f2 -d\" | cut -f2 -d\/`
	        #        datasrc_dir="`pwd`/data"
	        #        cp $datasrc_dir/*.desktop $desktop_dir
	        #        chmod +x $desktop_dir/*.desktop
	        #fi
	fi
	rm -r /tmp/fs_fbm
	
fi


