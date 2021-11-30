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


weekly_report="/tmp/weekly_report.md"
# remove existing report
if [ -f "$weekly_report" ]; then
    rm $weekly_report
fi

echo "$HOSTNAME - Weekly system report" >> $weekly_report  
echo "" >> $weekly_report
echo "" >> $weekly_report
#echo "" >> $weekly_report
# ##############################################################
# System information
# ##############################################################
os_version=$(lsb_release -d | grep -i "Des" |cut -d ":" -f 2|awk '{$1=$1};1')
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{$2=$2/1024; print $2,"MB";}')
NO_CPUS=$(grep -c ^processor /proc/cpuinfo)
TIMEZONE=$(date +%Z)

echo "System information:"  >> $weekly_report
echo ""  >> $weekly_report

echo "Operating system | $os_version " >> $weekly_report
echo "Kernel            | $(uname -r )" >> $weekly_report
echo "Timezone          | $TIMEZONE " >> $weekly_report
echo "Memory            | $MEM_TOTAL " >> $weekly_report 
echo "CPUs              | $NO_CPUS " >> $weekly_report 
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

