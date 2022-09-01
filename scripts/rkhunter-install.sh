#!/bin/bash
# Kindly make sure that EPEL repo is enabled in yum configuration.
yum install rkhunter

# Modify rkhunter configuration

# UPDATE_MIRRORS=1
sed -i -e 's/^#UPDATE_MIRROR=0/UPDATE_MIRROR=1/g' /etc/rkhunter.conf
# MIRRORS_MODE=0
sed -i -e 's/^#MIRRORS_MODE=0/MIRRORS_MODE=0/g' /etc/rkhunter.conf

MAIL-ON-WARNING=root@localhost
# sed -i -e 's/^MAIL-ON-WARNING\=.*/MAIL-ON-WARNING=root@localhost/g' /etc/rkhunter.conf
sed -i -e 's/^(\#?)(MAIL-ON-WARNING)(\=.*)/MAIL-ON-WARNING=root@localhost/g' /etc/rkhunter.conf

MAIL_CMD=mail -s "[rkhunter] Warnings found for ${HOST_NAME}"
sed -i -e 's/.*MAIL-CMD.*/MAIL_CMD=mail -s "[rkhunter] Warnings found for ${HOST_NAME}"/g' /etc/rkhunter.conf

#updates rkhunter text data files
rkhunter --update

#Set the Security Baseline for your system by creating a fresh database
rkhunter --propupd

#checks for rootkits without keypress needed & shows only warnings
rkhunter --check --sk --rwo

# RKHunter log file is: /var/log/rkhunter.log
# You may get warning on some files/directories. To whitelist, ALLOWHIDDENDIR

# All recent versions of rkhunter have a cronjob preinstalled under the /etc/cron.daily directory.
# As a system admin, monitor rkhunter.log file and if any suspicious file change(s) are found, raise 
#alerts

###
# Ref: 
# https://www.woktron.com/secure/knowledgebase/79/Installation-Rootkit-Hunter-rkhunter-on-CentOS.html
# https://isaac.tips/security/installing-rkhunter-on-ubuntu/
# https://raw.githubusercontent.com/MediaCluster/SysAdminScripts/master/rkhunter-whitelist.sh

