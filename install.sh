#!/bin/bash

#assuming most users are linux
BASHFILE=~/.bashrc
# linux or mac
echo "Linux (0) or mac (1) user:"
read osvalue

case $osvalue in
    0)
      #no change
      ;;
    1)
      #change to .bash_profile for mac users
      BASHFILE=~/.bash_profile
      ;;
    *)
      #bad input
      echo "bad input ->" $osvalue
      exit
      ;;
esac

#adding new line for prettyness
echo ' ' >> $BASHFILE

#sourcing file for command use
echo "source ~/Documents/TextSSH/.TextEditOpen.sh" >> $BASHFILE
echo "Input the user and host for the desired ssh client (e.g. user@hostname or user@1.1.1.1)"
read host_val
echo export TEXTSSH_HOSTNAME=$host_val >> $BASHFILE
echo "Input path to desired text editting application (e.g. /path/to/app)"
read path_val
echo export TEXTSSH_APP_PATH=$path_val >> $BASHFILE
chmod u+x .TextEditOpen.sh
echo "if any mistakes were made providing either the application path or host name changes can be made to the $BASHFILE"
echo "making directory for use"
mkdir /etc/TextSSH.d
chown "$SUDO_USER" /etc/TextSSH.d
mkdir /etc/TextSSH
#mv ./.TextEditOpen.sh
#mv ./* /etc/TextSSH


if [ 1 == 1 ] #temp values
then
  source $BASHFILE
  echo "!!SUCCESS!!"
  echo "!Please restart terminal to take effect!"
else
  echo "try running file as sudo"
fi