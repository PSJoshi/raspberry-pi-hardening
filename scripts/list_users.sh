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



 
