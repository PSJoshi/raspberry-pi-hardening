#!/bin/bash
# Kindly make sure that EPEL repo is enabled in yum configuration.
yum install rkhunter
# Before scanning, do rkhunter configuration
cat >> /etc/rkhunter.conf << EOF
UPDATE_MIRRORS=0
# The MIRRORS_MODE option tells rkhunter which mirrors are to be used when
# the '--update' or '--versioncheck' command-line options are given.
# Possible values are:
#     0 - use any mirror
#     1 - only use local mirrors
#     2 - only use remote mirrors

MIRRORS_MODE=0
WEB_CMD=""
MAIL-ON-WARNING=root@localhost
MAIL_CMD=mail -s "[rkhunter] Warnings found for ${HOST_NAME}"
EOF

# modify default configuration
cat >> /etc/default/rkhunter <<EOF
CRON_DAILY_RUN="true"
CRON_DB_UPDATE="false"
DB_UPDATE_EMAIL="false"
REPORT_EMAIL="root"
APT_AUTOGEN="false"
EOF

# check if config is right
sudo rkhunter -C

# you can see the log by cat /var/log/rkhunter.log
# or you can print warning to console only

#updates rkhunter text data files
rkhunter --update

#Set the Security Baseline for your system by creating a fresh database
rkhunter --propupd

#checks for rootkits without keypress needed & shows only warnings
rkhunter --check --sk --rwo --enable all --disable none

# RKHunter log file is: /var/log/rkhunter.log
# You may get warning on some files/directories. To whitelist, ALLOWHIDDENDIR

# All recent versions of rkhunter have a cronjob preinstalled under the /etc/cron.daily directory.
# As a system admin, monitor rkhunter.log file and if any suspicious file change(s) are found, raise 
#alerts

# If you wish, you can set up cron job to run on 4:15 am
#crontab -l | { cat; echo '15 04 * * * /usr/bin/rkhunter --cronjob --update --quiet'; } | crontab -

###
# Ref: 
# https://www.woktron.com/secure/knowledgebase/79/Installation-Rootkit-Hunter-rkhunter-on-CentOS.html
# https://isaac.tips/security/installing-rkhunter-on-ubuntu/
# https://raw.githubusercontent.com/MediaCluster/SysAdminScripts/master/rkhunter-whitelist.sh

