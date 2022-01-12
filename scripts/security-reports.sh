#!/bin/bash

echo "Generating lynis report"
echo ""
lynis audit system | grep -Pzo '.*Warnings(.*\n)*' > "lynis.report"
echo ""
echo ""
echo ""

echo "Generating rkhunter report"
echo ""
touch /usr/local/scripts/report/rkhunter.report 
rkhunter --configfile /etc/rkhunter.conf --report-warnings-only --logfile /usr/local/scripts/report/rkhunter.report

echo "Generating aide report"
echo ""
# the command given below will create log file in /var/log/aide/aide.log
/usr/bin/aide.wrapper --config /etc/aide/aide.conf --check 
touch /usr/local/scripts/report/aide.report 
cp /var/log/aide/aide.log /usr/local/scripts/report/aide.report 

echo "Generating fail2ban report"
grep -i "Ban " /var/log/fail2ban.log 

echo "Generating logwatch report"
logwatch --detail high --range today --service all > /usr/local/scripts/report/logwatch.report

echo "Generating unhide report"
unhide -m -d sys procall brute reverse -f /usr/local/scripts/report/unhide.log
unhide-tcp >> /usr/local/scripts/report/unhide.log

