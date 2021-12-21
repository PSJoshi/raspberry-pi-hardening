#!/bin/bash
#name: list_users.sh
#Purpose: list all normal users and system users
#author: Pradyumna Joshi

file_login_def="/etc/login.defs"
file_password="/etc/passwd"
 
#get min UID limit
uid_min=$(grep "^UID_MIN" $file_login_def)
 
#get max UID limit
uid_max=$(grep "^UID_MAX" $file_login_def)

echo ""
echo "System User Accounts:"
awk -F':' -v "min=${uid_min##UID_MIN}" -v "max=${uid_max##UID_MAX}" '{ if ( !($3 >= min && $3 <= max  && $7 != "/sbin/nologin" && $7 != "/bin/false" )) print $0 }' "$file_password"
echo ""

echo ""
#use awk to print if UID >= $MIN and UID <= $MAX and shell is not /sbin/nologin or /bin/false 
echo "Normal User Accounts:\n"
awk -F':' -v "min=${uid_min##UID_MIN}" -v "max=${uid_max##UID_MAX}" '{ if ( $3 >= min && $3 <= max  && $7 != "/sbin/nologin" ) print $0 }' "$file_password"

echo ""
echo "Valid users"
user_info=`awk -F':' -v "min=${uid_min##UID_MIN}" -v "max=${uid_max##UID_MAX}" '{ if ( $3 >= min && $3 <= max  && $7 != "/sbin/nologin" && $7 != "/bin/false" ) print $0 }' "$file_password" | cut -d: -f1`

echo $user_info

# change password expiry info for the user(s)
# good ref: https://www.thegeekstuff.com/2009/04/chage-linux-password-expiration-and-aging/
# disable password aging
  #chage -m 0 -M 99999 -I -1 -E -1 <user>
  #sudo /usr/bin/chage -E "2025-12-01" -M 30000 -W 30 -I 10 $u 
for u in $user_info
do
    echo $u
    sudo /usr/bin/chage -M 5000 $u
    chage -l $u
done


 
