#!/bin/bash
users=$(cut -d: -f1 /etc/passwd)

if [ ! -z "$users" ]; then
  for user in $users
    do
      # Set permissions for admin user's home directory.
      chmod 700 "/home/$user"
      #echo $user
    done
#else
#    echo "no users!"
fi
