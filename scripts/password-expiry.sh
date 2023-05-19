#!/bin/bash

SUB="nologin"
pass_expiry_days=1000

for USER_Entry in $(cat /etc/passwd | cut -d':' -f 1,7)
do
  if [[ "$USER_Entry" == *"$SUB"* ]]; then
    echo ""
  else
    name=$(echo $USER_Entry|cut -d ":" -f1)
    # echo $name
    if [ "$(chage -l $name | grep 'Password expires' | cut -d':' -f2 | tr -d " ")" == 'never' ]; then
    echo "Changing password expiry for $name"
    # change password expiry to approx. 
      chage -E $pass_expiry_days $name
    fi

  fi
done
