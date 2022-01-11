### AIDE report script
#!/bin/bash
/bin/cat /var/log/aide/aide.log | /bin/grep -v failed >> /usr/local/scripts/report/aide_report.txt
/bin/echo "**************************************" >> /usr/local/scripts/report/aide_report.txt
/usr/bin/tail -100 /var/log/aide/aide.log >> /usr/local/scripts/report/aide_report.txt
/bin/echo "****************DONE******************" >> /usr/local/scripts/report/aide_report.txt
