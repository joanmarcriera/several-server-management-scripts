#!/bin/sh
#TODO
#check if snmpd is installed , otherwise install

mv /etc/default/snmpd{,.orig}
mv /etc/snmp/snmpd.conf{,.orig}

wget http://suportrecerca.MYEDITEDDOMAIN.org/Utilitats/snmp/snmpd -O /etc/default/snmpd
wget http://suportrecerca.MYEDITEDDOMAIN.org/Utilitats/snmp/snmpd.conf -O /etc/snmp/snmpd.conf
/etc/init.d/snmpd restart
return 0
