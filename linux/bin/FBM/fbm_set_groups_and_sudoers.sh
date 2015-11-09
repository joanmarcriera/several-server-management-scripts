#!/bin/sh
#TODO
#check if hostname starts with wl => is a workstation
# if is a workstation ask for a user to get admin rights
#hola soy Nacho
#adios 
# 



sed -i "s/%admin ALL=(ALL) ALL/%admin ALL=(ALL) NOPASSWD:ALL/g" /etc/sudoers
sed -i "s/%sudo ALL=(ALL) ALL/%sudo ALL=(ALL) NOPASSWD:ALL/g" /etc/sudoers

sed -i "s/:sysop/:sysop,admmarc,admnacho,admalbert,admgonzalo,admlinux,FBMAdmin/g" /etc/group


return 0
