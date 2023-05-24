#!/bin/bash

# This scripts monitors server utilization and can be used to alert system admin.
# Ensure that sysstat and iproute2 package(s) are installed on the system
# Tested on CentOS

echo "Tracking Server utilization"
date;
echo "Uptime:"
uptime
echo "Current users:"
w
echo "*************"
echo "Last logins:"
last -a |head -3
echo "***********************"
echo "Disk and memory usage:"
df -h | xargs | awk '{print "Free/total disk: " $11 " / " $9}'
free -m | xargs | awk '{print "Free/total memory: " $17 " / " $8 " MB"}'
echo "******************************"
start_log=`head -1 /var/log/messages |cut -c 1-12`
oom=`grep -ci kill /var/log/messages`
echo -n "Tracking Out of memory(OOM) errors since $start_log :" $oom
echo ""
echo "*****************************************"
echo "Utilization and most expensive processes:"
top -b |head -3
echo
top -b |head -10 |tail -4
echo "*************************"
echo "Open TCP ports:"
nmap -p- -T4 127.0.0.1
echo "**************************"
echo "Current connections:"
ss -s
echo "--------------------"
echo "processes:"
ps auxf --width=200
echo "--------------------"
echo "vmstat:"
vmstat 1 5

