#!/bin/bash - 
#===============================================================================
#
#          FILE:  fbm_legato_install.sh
# 
#         USAGE:  ./fbm_legato_install.sh 
# 
#   DESCRIPTION:  install legato function to be called
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Joan Marc Riera Duocastella (), marc.riera@barcelonamedia.org
#       COMPANY: Fundació Barcelona Media
#       CREATED: 12/22/2010 11:09:54 AM CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

installLegato(){
	echo "xx.tt.rr.uu  aplicweb aplicweb.corp.barcelonamedia.org"  >> /etc/hosts
	cd $TMPDIR
	case $MACH in
		i686)die "Architecture i686 is not available for install";; # :TODO:12/22/2010 11:10:34 AM CET:: check if is an vmware instance and suggest vcb backup
			
		x86_64) wget $SERVERMASTERURL/src/lgtoclnt_7.6-2_amd64.deb
			dpkg -X lgtoclnt_7.6-2_amd64.deb /;;
		*) echo -e "${RED}Error.... ${STD}" && die "Machine architecture mismach."	
	esac	
	[ -f /etc/init.d/networker ] && mv /etc/init.d/networker{,.$DATETIME} &&  echo "$RED File networker backed up on networker.$DATETIME"
	
	wget $SERVERMASTERURL/etc/init.d/networker -O /etc/init.d/networker
	chmod o+x /etc/init.d/networker
	update-rc.d -n networker defaults
	/etc/init.d/networker start
	return 0
}
