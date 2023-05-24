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

