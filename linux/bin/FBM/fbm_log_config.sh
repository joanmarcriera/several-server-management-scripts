#!/bin/bash - 
#===============================================================================
#
#          FILE:  fbm_log_config.sh
# 
#         USAGE:  ./fbm_log_config.sh 
# 
#   DESCRIPTION:  configure rsyslog , send basic logs to fbmlog01
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Joan Marc Riera Duocastella (), marc.riera@barcelonamedia.org
#       COMPANY: Fundació Barcelona Media
#       CREATED: 03/03/2011 01:23:43 PM CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

[ -d /etc/rsyslog.d ] && [ ! -f /etc/rsyslog.d/99-fbm.conf ] && cat > /etc/rsyslog.d/99-fbm.conf << EOF


# FBM syslog server

auth.*,authpriv.*       @fbmlog01
kern.warn               @fbmlog01
kern.err                @fbmlog01
mail.*                  @fbmlog01

EOF
/etc/init.d/rsyslog restart
