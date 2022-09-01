#!/bin/sh

# rkhunter whitelist script for parsing rkhunter logs in /var/log/rkhunter/rkhunter.log
# http://rkhunter.cvs.sourceforge.net/viewvc/rkhunter/rkhunter/files/FAQ

LOG=/var/log/rkhunter.log
cat <<EOF

WHITELISTING Filess/Directories/Scripts - some examples
After Rootkit Hunter has run you may encounter items in the log file you would like to whitelist. First verify that the entries are safe to add. The results of running these commands can be added to your 'rkhunter.conf.local' configuration file. Please adjust the commands, and the location of your 'rkhunter.log' log file, and verify the results before adding them. Do not automate adding whitelist entries to your configuration file.

EOF

echo '
     Allow script replacements ("properties" test):'
     awk -F"'" '/replaced by a script/ {print "SCRIPTWHITELIST="$2}' $LOG
echo '
     Allow processes using deleted files ("deleted_files" test):'
     awk '/Process: / {print "ALLOWPROCDELFILE="$3}' $LOG | sort -u
echo '
     Allow Xinetd services:'
     awk '/Found enabled xinetd service/ {print $NF}' $LOG |
      xargs -iX grep -e "server[[:blank:]]" 'X' | awk '{print "XINETD_ALLOWED_SVC="$NF}'
echo '
     Allow packet capturing applications ("packet_cap_apps" test):'
     awk -F"'" '/is listening on the network/ {print "ALLOWPROCLISTEN="$2}' $LOG
echo '
     Allow "suspicious" files ("filesystem" test):'
     grep '^\[..:..:..\][[:blank:]]\{6\}.*/dev/shm/.*:' $LOG |
      awk '{print "ALLOWDEVFILE="$2}' | sed -e "s|:$||g"
echo '
     Allow hidden directories ("filesystem" test):'
     awk '/Warning: Hidden directory/ {print "ALLOWHIDDENDIR="$6}' $LOG
echo '
     Allow hidden files ("filesystem" test):'
     awk '/Warning: Hidden file/ {print "ALLOWHIDDENFILE="$6}' $LOG |
      sed -e "s|:$||g"
