#!/bin/bash
# This script can be used to establish a security baseline for the Linux system.
# Later on, you can compare the script output with the latest version of new baseline
# and can be used to track the changes happening in the system.
# This script can be a useful tool in any forensic investigation as it allows you 
# glance through various software/services and assess the state of system for any 
# anomalous activities.

######################################################
#       Security Baseline Tool for Linux #
#                      Version 0.1                   #
#----------------------------------------------------#
#           Written by: Pradyumna Joshi              #
#                                                    #
#                   GNU GPL v 3.0                    #
######################################################
AUDIT_DIR="/tmp/"

function check_root() {
    echo ""
    echo "Checking for root/sudo priviliges: "
    echo ""
    if whoami | grep "root"; then
     echo "Congratulations! You have root/sudo privileges..." 
    else
     echo "!!! YOU ARE NOT ROOT !!!  PLEASE RE-RUN THE SCRIPT WITH ROOT PRIVILIGES!" && exit
    fi
}

# check if the user is root or not 
check_root 

server_name=$(hostname)
echo "Security baseline report for $server_name " 
echo "Report generated on $(date +%d-%m-%Y)"
echo ""
echo ""


#Create the file name of collection file(s).

day=$(date +"%d-%m-%Y")
hostname=$(hostname -s)
collection="$hostname.$day"
memory_image="$hostname.$day.mem"

#Create a log file of the collection process.

echo "Creating Log File..."
baseline_collection_log="$collection.BASELINE.log"
touch $AUDIT_DIR/$baseline_collection_log

#Print start message to screen and log file.
echo "######################################################" >> $AUDIT_DIR/$baseline_collection_log
echo "#       Security Baseline Tool for Linux #" >> $AUDIT_DIR/$baseline_collection_log
echo "#                      Version 0.1                   #" >> $AUDIT_DIR/$baseline_collection_log
echo "#----------------------------------------------------#" >> $AUDIT_DIR/$baseline_collection_log
echo "#           Written by: Pradyumna Joshi              #" >> $AUDIT_DIR/$baseline_collection_log
echo "#                   GNU GPL v 3.0                    #" >> $AUDIT_DIR/$baseline_collection_log
echo "######################################################" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIR_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log


echo "Collecting Security Basline information..." | tee -a $AUDIT_DIR/$baseline_collection_log

#Collect Linux System Information

echo " " >> $AUDIT_DIR/$baseline_collection_log
echo "Collecting system information..." | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo " " >> $AUDIT_DIR/$baseline_collection_log
echo "Host name:" >> $AUDIT_DIR/$baseline_collection_log
echo "hostnamectl:" | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
hostnamectl | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Collecting OS and Kernel information:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
echo "OS and kernel:" | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
uname -a | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "System date/time/timezone:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
timedatectl | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Uptime:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
uptime | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Free memory:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
free | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Memory details :" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
cat /proc/meminfo | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Last reboot time:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
last reboot | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Users currently logged on:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
who -H | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Last system boot:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
who -b | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "User accounts on the machine:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
cat /etc/passwd | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "User groups on the machine:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
cat /etc/group | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Sudoers configuration file:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
cat /etc/sudoers | grep -v ^#|grep -v ^$ | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Scheduled jobs in crontab:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
cat /etc/crontab |grep -v ^#|grep -v ^$ | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Scheduled jobs in cron directory:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
cat /etc/cron.*/* |grep -v ^#|grep -v ^$ | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Hardware information as reported by OS" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
lshw | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "CPU's properties and architecture as reported by OS:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
lscpu | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Block devices:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
lsblk -a | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "USB Devices:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
lsusb -v | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "PCI devices:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
lspci -v | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "SCSI devices:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
lsscsi -s | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Hard drives:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
fdisk -l | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Mountable partitions by GRUB:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
blkid | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Mounted file systems:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
df -h | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Mount points on the machine:" >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
cat /proc/mounts | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Collecting System information... DONE!" | tee -a $AUDIT_DIR/$baseline_collection_log


#Now, collect running processes on the system

echo " " >> $AUDIT_DIR/$baseline_collection_log
echo "Collecting list of processes..." >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Running processes with PID (numerically sorted):" >> $AUDIT_DIR/$baseline_collection_log
pstree -p -n | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List running processes with command line arguments:" >> $AUDIT_DIR/$baseline_collection_log
pstree -a | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List running processes:" >> $AUDIT_DIR/$baseline_collection_log
ps -axu | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List all processes running from /tmp or /dev directory:"
ls -alR /proc/*/cwd 2> /dev/null | grep -E "tmp|dev" | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of deleted binaries still running:"
ls -alR /proc/*/exe 2> /dev/null | grep -i "deleted" | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Startup services at boot:"
systemctl list-unit-files --type=service | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of services and their status:" >> $AUDIT_DIR/$baseline_collection_log

service --status-all | tee -a  $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Collecting list of processes... DONE!" >> $AUDIT_DIR/$baseline_collection_log

#Now, collect Network Information.

echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Collecting network information..." | tee -a $AUDIT_DIR/$baseline_collection_log

echo "List of network devices:" >> $AUDIT_DIR/$baseline_collection_log
ifconfig -a | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Firewall status:" >> $AUDIT_DIR/$baseline_collection_log
systemctl status iptables.service | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Firewall (iptables) rules :" >> $AUDIT_DIR/$baseline_collection_log
iptables -n -L -v | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of open files on the system and associated process ID:" >> $AUDIT_DIR/$baseline_collection_log
lsof | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of network connections:" >> $AUDIT_DIR/$baseline_collection_log
netstat -a | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of network interfaces:" >> $AUDIT_DIR/$baseline_collection_log
netstat -i | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of kernel network routing table:" >> $AUDIT_DIR/$baseline_collection_log
netstat -r | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of network connections:" >> $AUDIT_DIR/$baseline_collection_log
netstat -nalp | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of Network Connections:" >> $AUDIT_DIR/$baseline_collection_log
netstat -plant | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of the ARP table cache (Address Resolution Protocol):" >> $AUDIT_DIR/$baseline_collection_log
arp -a | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Collecting network information... DONE!" | tee -a $AUDIT_DIR/$baseline_collection_log


#Create a directory listing of ALL files.

echo " " >> $AUDIT_DIR/$baseline_collection_log
echo "Generating list for potential malicious files/directories "
echo " " >> $AUDIT_DIR/$baseline_collection_log

#echo "CREATING DIRECTORY LISTING OF FILES..." | tee -a $AUDIT_DIR/$baseline_collection_log
#echo "FULL DIRECTORY LISTING: " >> $AUDIT_DIR/$baseline_collection_log
#ls -l -A -h -R / | tee -a  $AUDIT_DIR/$baseline_collection_log
#echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List ALL hidden files:" >> $AUDIT_DIR/$baseline_collection_log
find / -type f -name "\.*" | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List ALL hidden directories:" >> $AUDIT_DIR/$baseline_collection_log
find / -type d -name "\.*" | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of files/directories with no user/group name:" >> $AUDIT_DIR/$baseline_collection_log
find / \( -nouser -o -nogroup \) -exec ls -l {} \; 2>/dev/null | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List of MD5 hash for all executable files:" >> $AUDIT_DIR/$baseline_collection_log
find /usr/bin -type f -exec file "{}" \; | grep -i "elf" | cut -f1 -d: | xargs -I "{}" -n 1 md5sum {} | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "List ALL log files that contain binary code inside:" >> $AUDIT_DIR/$baseline_collection_log
grep [[:cntrl:]] /var/log/*.log | tee -a $AUDIT_DIR/$baseline_collection_log
echo " " >> $AUDIT_DIR/$baseline_collection_log

echo "Generating list for potential malicious files/directories... Done"
echo " " >> $AUDIT_DIR/$baseline_collection_log
