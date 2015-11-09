#!/bin/bash -x

# Script de instalacion de QAS en un desktop
# El script llama a fbm_qas_install.expect, donde se ejecutan instrucciones expect. 

# Las salidas por pantalla, se redirigen al fichero output.expect.o
# Los errores se redirigen al fichero output.expect.e # :TODO:01/14/2011 10:32:18 AM CET:: unificar output
exec 1>./output.expect.o
exec 2>./output.expect.e

# Definicion de variables.
USERNAME="xxxxx"
PASS="xxxxxx"
SERVERIP="xx.tt.rr.uu"
SERVERPATH="scripts"
MASTERURL="http://$SERVERIP/$SERVERPATH"

# Funcion para instalar paquete 'smbfs'.
installsmbfs(){
	 echo "Installing smbfs"
	 apt-get update
	 apt-get -y upgrade
	 apt-get -y autoremove
	 apt-get -y install smbfs 
}

 # :TODO:01/14/2011 10:32:34 AM CET:: smbfs is not necessary 
# Comprueba si el paquete 'smbfs' esta instalado en el sistema. Si no lo esta, ejecuta la funcion 
# llamada 'installsmbfs'.
dpkg-query -l 'smbfs'
[ "$?" -eq  "0" ] && echo "smfs is already installded. Keep going" || installsmbfs

 # :TODO:01/14/2011 10:32:34 AM CET:: smbfs is not necessary 
# Comprueba si el paquete 'smbfs' esta instalado en el sistema. Si lo esta, no hace nada.
dpkg-query -l 'smbfs'
[ "$?" -eq  "0" ] && echo "smfs has been installed. Keep going" || die " smfs can not be installed " 

# Modifica un parametro del fichero /etc/ssh/sshd_config y reinicia el servicio sshd
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
/etc/init.d/ssh reload
 # :TODO:01/14/2011 10:32:58 AM CET:: check if directory already existes , also check if files already exist
# Descarga ficheros vas.conf y vgp.conf en sus rutas correspondientes
mkdir -p /etc/opt/quest/vas
mkdir -p /etc/opt/quest/vgp
wget $MASTERURL/etc/opt/quest/vas/vas.conf  -O /etc/opt/quest/vas/vas.conf
wget $MASTERURL/etc/opt/quest/vgp/vgp.conf  -O /etc/opt/quest/vgp/vgp.conf

# Modifica el template vas.conf. Escribe el nombre del PC
sed  -i "s/%%HOSTNAME%%/`hostname`/g" /etc/opt/quest/vas/vas.conf

[ -d /home/sysop/fs ] && echo "fs exists" || echo "fs does not exist"
[ -d /home/sysop/fs/QAS_4_0_1_22 ] && echo "QAS dir  exists" || echo "QAS dir  does not exist"

cd /home/sysop
 # :TODO:01/14/2011 10:33:33 AM CET:: this should be done on /tmp
wget $MASTERURL/src/QAS_4.tgz
tar xvzf QAS_4.tgz

cd /home/sysop/QAS_4_0_1_22
./install.sh -q vasclnt
./install.sh -q vasgp
/opt/quest/bin/vastool configure pam common-password

apt-get -y install expect
############################# install qas
tempscript="fbm_qas_install.expect"
if [ ! -f ./$tempscript ]
then
        wget $MASTERURL/bin/$tempscript
fi
chmod +x $tempscript
./$tempscript $USERNAME $PASS

exit 0
