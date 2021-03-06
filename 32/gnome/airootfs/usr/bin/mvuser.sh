#!/bin/sh
clear
  _note="You can only rename the user once."
  _givecorrectname="Please enter a valid username. (lowercase, can't start with a figure)"
  _givename="Enter the new username"
  _givepass="Type the pasword for the new user :"
  _modfiles="Modified files :"
  _modfilesend="Modification of the config files finished !"
  _renaminguser="Renaming user..."
  _alreadydone="The user has already been renamed !"
  _pressenter="Press enter..."
if [ -e /home/live ];then
  echo "$_note"
  echo
  echo -en "$_givename\n=> " && read
  while [ -z "$(echo $REPLY |grep -E '^[a-z_][a-z0-9_-]*[$]?$')" ];do
   echo "$_givecorrectname"
   echo -n '=> ' && read
  done  
  
  usr1="live"
  usr2="$REPLY"
  echo "$_givepass"
  while true; do
   passwd $usr1 && break
  done
  sync
  IFS='
'
  echo "$_modfiles"
  for i in $(find /home/$usr1/.??* -type f);do grep "home/$usr1" $i >/dev/null && sed -i "s|home/$usr1|home/$usr2|g" $i && echo $i;done
  echo "$_modfilesend"
  sleep 1
  echo "$_renaminguser"
  sed -i "s/$usr1/$usr2/g" /etc/group
  sed -i "s/$usr1/$usr2/g" /etc/gshadow
  sed -i "s/$usr1/$usr2/g" /etc/passwd
  sed -i "s/$usr1/$usr2/" /etc/shadow
  sed -i "s/$usr1/$usr2/" /etc/inittab
  mv /home/$usr1 /home/$usr2 &> /dev/null
  rm /home/$usr2/.bash_profile &> /dev/null
  chown -R $usr2:users /home/$usr2
  chgrp $usr2 /home/$usr2 &> /dev/null
else
  echo "$_alreadydone"
  echo "$_pressenter"
  read
fi
