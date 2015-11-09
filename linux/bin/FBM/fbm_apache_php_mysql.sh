#!/bin/bash - 
#===============================================================================
#
#          FILE:  fbm_apache_php_mysql.sh
# 
#         USAGE:  ./fbm_apache_php_mysql.sh 
# 
#   DESCRIPTION:  install apache + php + mysql
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Joan Marc Riera Duocastella (), marc.riera@barcelonamedia.org
#       COMPANY: Fundació Barcelona Media
#       CREATED: 03/03/2011 01:40:16 PM CET
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

installPkg php5 php5-mysql libapache2-mod-php5 mysql-server 
