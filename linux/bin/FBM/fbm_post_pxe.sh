#!/bin/bash -x 

#TODO: test - SG 
#TODO: test - SG 2


 # :TODO:01/17/2011 05:07:09 PM CET:: move output to fbmlog01 and delete from local
logger -i -s "$0 - launched"
LOGFILE=$0.log
cd /tmp
exec 1>>$LOGFILE
exec 2>>$LOGFILE

#TODO
#install qas  - from expect - gonzalo
## en proximas ediciones
#if server
	#ip fixa
	#snmpd
	#legato

	#if virtual
		#vmware tools


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



################################### install basic packages
tempscript="fbm_basic_packages_install.sh"
if [ ! -f ./$tempscript ] 
then
	wget $MASTERURL/bin/$tempscript
	. ./$tempscript
	rm $tempscript
fi
################################### configure groups
tempscript="fbm_set_groups_and_sudoers.sh"
if [ ! -f ./$tempscript ]
then 
	 wget $MASTERURL/bin/$tempscript
	 . ./$tempscript
	 rm $tempscript
fi
################################### hostname change in case is kickseed
###########TODO this must be fixed.
hostnameGet "kickseed" # returns 0 if it's kickseed
if [ $? -eq 0 ]
then
	 tempscript="fbm_set_hostname.sh"
	 if [ ! -f ./$tempscript ]
	 then
		  wget $MASTERURL/bin/$tempscript
		  #demanar quin es el nom de la maquina # aixo peta
		  # read -p "La maquina no es pot dir \"kickseed\", quin nom li hem de posar:" name
		  name="workstationsensenom"
		  . ./$tempscript 
		  hostnameSet $name
		  rm $tempscript
	 fi
fi


################################### prepare QAS files
tempscript="fbm_qas_install.sh"
if [ ! -f ./$tempscript ]
then
	 wget $MASTERURL/bin/$tempscript
	 chmod +x $tempscript
fi
./$tempscript

###################################
###################################
################################### is server - proximes edicions


###################################



exit 0
