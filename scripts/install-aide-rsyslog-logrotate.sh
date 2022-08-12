#!/bin/bash
# This script installs packages -  rsyslog, logrotate and aide

#check to see if script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

### file integrity aide installation
yum list installed aide
if ! [ $? -eq 0 ]; then
    yum -y install aide 
    /usr/sbin/aide --init 
    mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# AIDE file integrity check service
cat > /etc/systemd/system/aidecheck.service << "EOF"

[Unit]
Description=Aide Check

[Service]
Type=simple
ExecStart=/usr/sbin/aide --check

[Install]
WantedBy=multi-user.target


EOF

# AIDE timer service
cat > /etc/systemd/system/aidecheck.timer << "EOF"
[Unit]
Description=Aide check every day at 5AM

[Timer]
OnCalendar=*-*-* 05:00:00
Unit=aidecheck.service

[Install]
WantedBy=multi-user.target

EOF

chown root:root /etc/systemd/system/aidecheck.*
chmod 0644 /etc/systemd/system/aidecheck.*

# systemctl daemon-reload

# systemctl enable aidecheck.service
# systemctl --now enable aidecheck.timer

fi

### rsyslog installation
# check rsyslog version
yum list installed rsyslog
if [ $? -eq 0 ]; then
  rsyslogd -v |grep -i platform
  # check if rsyslogd is active and running
  systemctl status rsyslog
else
  yum -y install rsyslog
  systemctl start rsyslog
  systemctl enable rsyslog
  systemctl status rsyslog
fi

### Logrotate installation
yum install logrotate
cp /etc/logrotate.conf /etc/logrotate.conf.org
cat >  /etc/logrotate.conf << "EOF"
# rotate logs weekly
weekly
# use the adm group by default, since this is the owning group
# of /var/log/syslog.
su root adm
# keep 4 weeks of backlogs
rotate 4
# create new log files after rotating old one
create
# use date as suffix 
dateext
#compress log files
#compress

#RPM packages drop log rotation into this directory
include /etc/logrotate.d

# no packages own wtmp and btmp -- we will rotate them here
/var/log/wtmp {
monthly
create 0664 root utmp
   minsize 1M
   rotate 1
   notifyifempty
   mail root@localhost
}

/var/log/btmp {
monthly
missingok
notifyifempty
mail root@localhost
create 0600 root utmp
   rotate 1
}

EOF

