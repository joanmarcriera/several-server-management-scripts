#!/bin/bash - 
#===============================================================================
#
#          FILE:  fbm_munin_client.sh
# 
#         USAGE:  ./fbm_munin_client.sh 
# 
#   DESCRIPTION:  install munin and configure with apache and ssh
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Joan Marc Riera Duocastella (), marc.riera@barcelonamedia.org
#       COMPANY: Fundació Barcelona Media
#       CREATED: 03/03/2011 02:02:01 PM CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

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

installPkg munin-node munin-libvirt-plugins munin-plugins-extra apache2

[ -f /etc/apache2/mods-available/status.conf ] && mv /etc/apache2/mods-available/status.conf{,.bak} && wget $MASTERURL/etc/apache2/mods-available/status.conf -O /etc/apache2/mods-available/status.conf && /etc/init.d/apache2 restart || die  "Apache mod-status is not available, exiting. Check apache and run again"

[ -f /usr/share/munin/plugins/apache_accesses ] && ln -s '/usr/share/munin/plugins/apache_accesses' '/etc/munin/plugins/apache_accesses'
[ -f /usr/share/munin/plugins/apache_processes ] && ln -s '/usr/share/munin/plugins/apache_processes' '/etc/munin/plugins/apache_processes'
[ -f /usr/share/munin/plugins/apache_volume ] && ln -s '/usr/share/munin/plugins/apache_volume' '/etc/munin/plugins/apache_volume'


cat >> /etc/munin/munin-node.conf << EOF
allow ^84\.88\.79\.141$
EOF
/etc/init.d/munin-node restart

exit 0
