#!/bin/bash

# Weekly reporting script
# System admins get many daily reports that describe state
# of various services/daemons and the potential problems
# lurking around in the systems.
# Although useful, these daily reports quickly cause fatigue
# and many will overlook them as a routine issue.
# Basic purpose of weekly report is to summarize the activity
# of the system once a week. So the problems often overlooked
# in the daily report will be acted upon!!

# Presently, the script collects the following information:
# * Sysstat metrics
# * syslog messages
# * Apache/Nginx logs
# and many metrics can be added.


# You must be root to run this script; otherwise exit
# check if root user
#if [[ "$EUID" -ne 0 ]] ; then
#   echo "This script MUST be run as root." 
#   exit 1
#fi

if ! [ $(id -u) = 0 ]; then
  echo "This script MUST be run as root."
   exit 1
fi

weekly_report="/tmp/weekly_report.md"
# remove existing report
if [ -f "$weekly_report" ]; then
    rm $weekly_report
fi

echo " $HOSTNAME - Weekly system report" >> $weekly_report  
echo "" >> $weekly_report
echo "" >> $weekly_report
#echo "" >> $weekly_report
# ##############################################################
# System information
# ##############################################################
os_version=$(lsb_release -d | grep -i "Description" |cut -d ":" -f 2|awk '{$1=$1};1')
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{$2=$2/1024; print $2,"MB";}')
NO_CPUS=$(grep -c ^processor /proc/cpuinfo)
TIMEZONE=$(date +%Z)

echo "System information:"  >> $weekly_report
echo ""  >> $weekly_report

echo "Operating system: $os_version " >> $weekly_report
echo "Kernel: $(uname -r )" >> $weekly_report
echo "Timezone: $TIMEZONE " >> $weekly_report
echo "Memory: $MEM_TOTAL " >> $weekly_report 
echo "CPUs: $NO_CPUS " >> $weekly_report 
echo "Uptime: $(uptime -p)" >> $weekly_report
echo " Machine name: $(uname -a| cut -d " " -f 1,2,3,4,5,12)" >> $weekly_report
echo "" >> $weekly_report
echo "" >> $weekly_report

# ###############################################################
# File system information
# ###############################################################
echo "File system:"  >> $weekly_report
echo ""  >> $weekly_report

df -Hl | grep -Ev "tmpfs|udev|snap|boot|Filesystem" | while read line; do 
    #echo "$line"
    echo "$line" | awk '{print "Filesystem size: "$2"  Used:"$3" Available:"$4" Percent:"$5" "}' >> $weekly_report
done; 

echo "" >> $weekly_report
echo "" >> $weekly_report
# ##############################################################
# System services
# ##############################################################
echo "System services:"  >> $weekly_report
echo ""  >> $weekly_report

failed_services=$(systemctl --failed | grep 'failed' | awk '{print $2}')
if [ -n $failed_services ]; then 
    echo "All services are running fine!" >> $weekly_report
else
    echo "Some of the services failed. Kindly investigate" >> $weekly_report
    echo "" >> $weekly_report
    echo "$failed_services" >> $weekly_report
    echo "" >> $weekly_report
fi
echo "" >> $weekly_report
echo "" >> $weekly_report

# Check if the system needs a reboot
if [ -e /var/run/reboot-required ]; then 
    echo "The system needs rebooting" >> $weekly_report
fi 
# ########################################################################
# Process accounting information
# #######################################################################
if [ -d /var/log/account ] ; then
    echo "Process accounting information:" >> $weekly_report
    echo "" >> $weekly_report
    echo "Last commands executed by root user" >> $weekly_report
    lastcomm root >> $weekly_report 
    echo "" >> $weekly_report
    echo "" >> $weekly_report    
    echo "User processes and their CPU times" >> $weekly_report
    sa -m >> $weekly_report
    echo "" >> $weekly_report
    echo "" >> $weekly_report
    echo "Connect time of all system users" >> $weekly_report
    ac -p >> $weekly_report
    echo "" >> $weekly_report
    echo "" >> $weekly_report
else
    echo "Process accounting is not enabled on the system. So, no process statistics could be generated!"
fi
    
# Kernel modules
echo "" >> $weekly_report
echo "Getting kernel module(s) information" >> $weekly_report
lsmod >> $weekly_report
echo "" >> $weekly_report

# RPC services
echo "" >> $weekly_report
echo "Getting RPC services information" >> $weekly_report
if command -v rpcinfo > /dev/null 2>&1; then
    rpcinfo -p >> $weekly_report
else
    echo "No RPC services are present on this system" >> $weekly_report
fi

echo "" >> $weekly_report
# mounted file systems
echo "Getting information about mounted file system:" >> $weekly_report
mount >> $weekly_report 
echo "" >> $weekly_report
echo "" >> $weekly_report

# Total no of installed packages
echo "" >> $weekly_report
echo "Total number of installed packages on the system:$(dpkg -l |grep -v "Listing" |wc -l)" >> $weekly_report
#apt list --installed|wc -l
echo "" >> $weekly_report

# process list
echo "" >> $weekly_report
echo "Getting process information:" >> $weekly_report
echo "" >> $weekly_report
ps auxwww >> $weekly_report
echo "" >> $weekly_report

# Network Interfaces information
echo "" >> $weekly_report
echo "Getting network interface(s) information:" >> $weekly_report
echo "" >> $weekly_report
ifconfig -a >> $weekly_report
echo "" >> $weekly_report


# sysctl parameters information
echo "" >> $weekly_report
echo "Getting system/kernel parameters information:" >> $weekly_report
if command -v sysctl > /dev/null 2>&1; then
    sysctl -a >> $weekly_report
fi

echo "" >> $weekly_report
echo "Getting information about the recent user(s) connections:" >> $weekly_report
last -25 >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about recent root user connections:" >> $weekly_report
last -5 root >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about X-access controls:" >> $weekly_report
if command -v xhost > /dev/null 2>&1; then
    xhost >> $weekly_report
else
    echo "X-Windows/GUI is not available!" >> $weekly_report
fi
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about X-access auth list:" >> $weekly_report
if command -v xauth > /dev/null 2>&1; then
    xauth list >> $weekly_report
else
    echo "X-Windows/GUI is not available!" >> $weekly_report
fi
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting history of commands executed on the system" >> $weekly_report
cat $HOME/.bash_history >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about LISTENING ports/services on the system" >> $weekly_report
netstat -natul >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting routing information" >> $weekly_report
netstat -rn >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting process socket information" >> $weekly_report
netstat -anp >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about IPv4 sockets:" >> $weekly_report
if command -v ss > /dev/null 2>&1; then
    ss -lnp4 >> $weekly_report
fi
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about IPv4 sockets:" >> $weekly_report
if command -v ss > /dev/null 2>&1; then
    ss -lnp6 >> $weekly_report
fi
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about IPv4 connections using lsof:" >> $weekly_report
if command -v lsof > /dev/null 2>&1; then
    lsof -i4 >> $weekly_report
fi
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about interprocess communication:" >> $weekly_report
if command -v ipcs > /dev/null 2>&1; then
    ipcs -m -a >> $weekly_report
    ipcs -p -a -t >> $weekly_report
fi
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting system environment variables information" >> $weekly_report
echo "Environment variables:\n $(env)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting umask information" >> $weekly_report
echo "Umask: $(umask)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting current runlevel information" >> $weekly_report
echo "Current Runlevel: $(who -r)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting ARP information" >> $weekly_report
echo "ARP entries:\n $(arp -a)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting DNS information" >> $weekly_report
echo "DNS entries:\n $(cat /etc/resolv.conf |grep -v ^#|grep -v ^$)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting Hostname information" >> $weekly_report
echo "Hostname :\n $(cat /etc/hosts)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting firewall rules information" >> $weekly_report
echo "Current firewall rules:\n $(iptables -nvL)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about physical partition table" >> $weekly_report
echo "Physical partition table information:\n $(fdisk -l)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about files with SUID/SGID bit set" >> $weekly_report
echo "Find all SUID/SGID files:\n $(find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \;)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about world writable files" >> $weekly_report
echo "Find all world-writable files:\n $(find / -type f  \( -perm -0002 -a ! -perm -1000 \) -exec ls -l {} \;)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about unowned directories and files" >> $weekly_report
echo "Find all unowned directories and files:\n $(find / -nouser -o -nogroup -exec ls -l {} \;)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting cron jobs information" >> $weekly_report
echo "Cron root jobs:\n $(crontab -u root -l)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting unlinked file(s) information" >> $weekly_report
echo "Unlinked file(s):\n $(lsof +L1)" >> $weekly_report
echo "" >> $weekly_report

echo "" >> $weekly_report
echo "Getting information about large files" >> $weekly_report
echo "Large size file(s):\n $(find / -size +10000k -exec ls -l {} \;)" >> $weekly_report
echo "" >> $weekly_report
