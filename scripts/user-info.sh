#!/bin/bash
# name: list_users.sh
# Purpose: list root users, user and its group(s) membership

echo "Get root users"
getent passwd 0

echo "List the user(s) which are in groups root, wheel adm and admin"
getent group root wheel adm admin

echo "list all the user and their group memebership"
getent passwd | cut -d : -f 1 | xargs groups

echo " List the users who can execute commands as root"
cat /etc/sudoers

echo " Find all the programs that can be executed with root privileges"
find / -perm -04000

echo " Listing root users"
getent group | grep 'x:0:' /etc/passwd | cut -d: -f1

echo "Listing non-system users"
eval getent passwd "{$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)}" | cut -d: -f1

echo "Listing sudo users"
getent group root wheel adm admin | cut -d: -f4

echo "Listing users with shell"
getent passwd | awk -F/ '$NF != "nologin" && $NF != "false" && $NF != "sync" && $NF != "!"' | cut -d: -f1
