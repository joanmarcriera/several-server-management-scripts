#!/bin/sh
#TODO 
# load library.sh and use library::die
# read the name from a file , less human intervention on install

die () {
            echo >&2 "$@"
                exit 1
}

hostnameSet(){
	 [ "$#" -eq 1 ] || die "1 argument required => (new hostname), $# provided"

	 HOSTNAME=$1 ;  export HOSTNAME
	 sed -i "s/kickseed/$HOSTNAME/g" /etc/hosts
	 sed -i "s/kickseed/$HOSTNAME/g" /etc/hostname
	 hostname -v $HOSTNAME
	 return 0
}
