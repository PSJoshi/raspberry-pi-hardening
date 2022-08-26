#!/bin/bash
yum install logwatch

sed -i -e '/Output =/ s/= .*/= mail/' /usr/share/logwatch/default.conf/logwatch.conf
sed -i -e '/MailTo =/ s/= .*/= my@email.com/' /usr/share/logwatch/default.conf/logwatch.conf
sed -i -e '/Detail =/ s/= .*/= Med/' /usr/share/logwatch/default.conf/logwatch.conf

# Status report
# logwatch --detail high --range yesterday --format html --filename meindateiname.html
# logwatch --detail high --range 'between 14 days ago and yesterday' --format html --mailto xxxxxxx@xxxx.xxx

