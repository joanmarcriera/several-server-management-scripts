#!/bin/bash - 
#===============================================================================
#
#          FILE:  fbm_linux_script.sh
# 
#         USAGE:  ./fbm_linux_script.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Joan Marc Riera Duocastella (), marc.riera@barcelonamedia.org
#       COMPANY: Fundació Barcelona Media
#       CREATED: 12/22/2010 11:04:09 AM CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
 # :TODO:12/22/2010 11:04:18 AM CET:: 
# treure la part d'autenticació o ferla necessessaria pero no deixarla comentada
#logger
#opció 3 install QAS
# opcio 4 install vmwaretools with expect
# clean temporal files al the end
# output unified to single file

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

############################################
installMonitCall(){
	MONITSH="fbm_monit_install.sh"
	[ ! -f ./$MONITSH ] && wget $MASTERURL/bin/$MONITSH
	. ./$MONITSH
	installMonit
}
installLegatoCall(){
	LEGATOSH="fbm_legato_install.sh"
	[ ! -f ./$LEGATOSH ] && wget $MASTERURL/BIN/$LEGATOSH
	. ./$LEGATOSH
	installLegato
}

####################################################################
# Print Menu
####################################################################
printMenu(){
#	if [[ "$user" = "" || "$passwd" = "" || "$port" = "" ]]; then
#		  echo -e "$RED Error: USER, PASS AND PORT ARE REQUIRED, PLEASE SET THEM IN CONFIG FILE $STD"
#		  echo ""
#		  echo ""
#		  die "l\'autenticació es necessaria" 
#	fi
	clear
		  echo -e "$CYAN Fast and Easy FBM Server Installation $STD"
		  echo "What do you want to do?"
		  echo -e "\t1) Install Monit.(root requiered)"
		  echo -e "\t2) Install legato. (root requiered) only amd64"
		  echo -e "\t3) Update and Install (Apache, PHP, MySQL, Django, Subversion, TRAC)"
		  echo -e "\t4) Configurating SSH and IPTABLES"
		  echo -e "\t5) Configure and securitizing Apache"
		  echo -e "\t6) Configure and securitizing MySQL"
		  echo -e "\t7) Create SVN & TRAC repos"
		  echo -e "\t8) Create a Mail Server"
		  echo -e "\t9) Create a cron backup (mysql, apache, trac & svn)"
		  echo -e "\t10) Set DNS and to add Google Apps MX records (Only SliceHost.com)"
		  echo -e "\t12) I do not know, exit!"
		  read option;
	while [[ $option -gt 12 || ! $(echo $option | grep '^[1-9]') ]]
		  do
		  printMenu
	 done
	 runOption
}

runOption(){
	case $option in
		 1) is_root && installMonitCall|| die "Must be root to install a service";;				
		2) is_root && installLegatoCall|| die "Must be root to install a service";;
		3) notImplemented;;
		4) notImplemented;;
		5) notImplemented;;
		6) notImplemented;;
		7) notImplemented;;
		8) notImplemented;;
		9) notImplemented;;
		10) notImplemented;;
		# 11) hooks_svn;;
		12) exit
	esac
echo "Press any Key to continue"
read x
printMenu
}


################# MAIN #########
printMenu
exit 0
