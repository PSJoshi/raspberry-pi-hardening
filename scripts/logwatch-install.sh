#!/bin/bash
yum install logwatch
# Logwatch adds itself to /etc/cron.daily/ for daily execution, so no configuration is mandatory.
# change e-mail options to suit your requirements
sed -i -e '/Output =/ s/= .*/= mail/' /usr/share/logwatch/default.conf/logwatch.conf
sed -i -e '/MailTo =/ s/= .*/= root@localhost/' /usr/share/logwatch/default.conf/logwatch.conf
sed -i -e '/Detail =/ s/= .*/= Med/' /usr/share/logwatch/default.conf/logwatch.conf

# Status report
# logwatch --detail high --range yesterday --format html --filename meindateiname.html
# logwatch --detail high --range 'between 14 days ago and yesterday' --format html --mailto xxxxxxx@xxxx.xxx

By default, logwatch runs as a daily cron service under ```/etc/cron.daily/00logwatch``` and reports are generated on a daily basis.
