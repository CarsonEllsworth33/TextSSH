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

#sets up a permanent alias for TextSSH
echo 'alias TextSSH=". ~/Documents/TextSSH/TextEditOpen.sh"' >> $BASHFILE
source $BASHFILE
echo "!!SUCCESS!!"
echo "!Please restart terminal to take effect!"