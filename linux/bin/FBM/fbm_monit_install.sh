#!/bin/sh
############################################
installMonit(){
	cd $TMPDIR
	case $MACH in
		i686)wget http://mmonit.com/monit/dist/binary/5.2.1/monit-5.2.1-linux-x86.tar.gz
			 tar -zxvf monit-5.2.1-linux-x86.tar.gz
			rm monit-5.2.1-linux-x86.tar.gz ;;
		x86_64)wget http://mmonit.com/monit/dist/binary/5.2.1/monit-5.2.1-linux-x64.tar.gz
			 tar -zxvf monit-5.2.1-linux-x64.tar.gz
			rm monit-5.2.1-linux-x64.tar.gz ;;
  		*) echo -e "${RED}Error ...${STD}" && die "Machine architecture mismach."
	esac
	[ ! -d /etc/monit/conf.d ] &&	mkdir -p /etc/monit/conf.d || die "/etc/monit/conf.d already exists. Clean previous install and try again."
	[ -f /etc/monit/monitrc ] && mv /etc/monit/monitrc{,.$DATETIME} && echo "$RED File monitrc backed up on monitrc.$DATETIME"

	wget -P /etc/monit/ $MASTERURL/etc/monit/monitrc
	chmod 600 /etc/monit/monitrc

	wget -P /etc/monit/conf.d/ $MASTERURL/etc/monit/conf.d/apache.conf

	wget -P /etc/monit/conf.d/ $MASTERURL/etc/monit/conf.d/sshd.conf	
	cp $TMPDIR/monit-5.2.1/bin/monit /usr/local/bin/

	wget -P /etc/init.d/ $MASTERURL/etc/init.d/monit
	chmod 700 /etc/init.d/monit 
	
	/etc/init.d/monit start
	update-rc.d monit defaults
	
	return 0
}
