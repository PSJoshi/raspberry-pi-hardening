#!/bin/bash
# Kindly make sure that EPEL repo is enabled in yum configuration.
yum install rkhunter

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

