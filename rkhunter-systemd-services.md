## rkhunter systemd services

rkhunter and its timer systemd services are given below:
A nice detailed description of various rkhunter options is available here:
https://x8t4.com/how-to-install-rkhunter-on-centos-7/

How to do offline update of rkhunter database
* https://neilzone.co.uk/2023/01/fixing-rkhunters-update-failed-error

Other links related to rkhunter:
* https://github.com/fstab50/RKinstaller/tree/master
* https://docs.e2enetworks.com/security/bestpractice/rootkit_hunter.html
* Sourceforge link - https://sourceforge.net/projects/rkhunter/files/
* 
### rkhunter.service script
```
# cat /etc/systemd/system/rkhunter.service
[Unit]
Description=Rootkit Scan using rkhunter

[Service]
Type=oneshot
#ExecStartPre=/usr/bin/rkhunter --propupd
#ExecStart=/usr/bin/rkhunter -check -sk --report-warnings-only
ExecStart=/usr/bin/rkhunter --cronjob --report-warnings-only
ExecStartPost=/usr/bin/rkhunter --propupd --report-warnings-only
SuccessExitStatus=1 2

[Install]
WantedBy=multi-user.target
```
Later, enable and start rkhunter.timer via systemctl
```
$ sudo systemctl enable rkhunter.service
$ sudo systemctl start rkhunter.service
```

### rkhunter.timer script
This script needs to be placed under /etc/systemd/system
rkhunter.timer script
```
# cat /etc/systemd/system/rkhunter.timer
[Unit]
Description=Daily Rootkit Scan
Requires=rkhunter.service

[Timer]
Unit=rkhunter.service
OnCalendar=05:00:00
Persistent=true

[Install]
WantedBy=timers.target
```
Later, enable and start rkhunter.timer via systemctl
```
$ sudo systemctl enable rkhunter.timer
$ sudo systemctl start rkhunter.timer
```

### rkhunter.conf.local

Usually, original rkhunter.conf that comes with package is customized as rkhunter.conf.local. A sample file is listed below:
```
UPDATE_MIRRORS=1
MIRRORS_MODE=0
WEB_CMD=""
PKGMGR=NONE
# Rootkit Hunter Custom Settings

## Allow some hidden directories/files
ALLOWHIDDENDIR=/etc/.git
ALLOWHIDDENFILE=/etc/.etckeeper
ALLOWHIDDENFILE=/etc/.gitignore
ALLOWHIDDENFILE=/etc/.updated

## Ignore the warnings: 'The command ... has been replaced by ...'
SCRIPTWHITELIST=/usr/sbin/ifdown
SCRIPTWHITELIST=/usr/sbin/ifup
SCRIPTWHITELIST=/usr/bin/egrep
SCRIPTWHITELIST=/usr/bin/fgrep
SCRIPTWHITELIST=/usr/bin/ldd

PORT_PATH_WHITELIST="/usr/sbin/avahi-daemon"
PORT_PATH_WHITELIST="/usr/sbin/dnsmasq"
```
### Delete existing rkhunter database and recreate new one
* Delete existing rkhunter data files
```
# ls -l  /var/lib/rkhunter/db/
backdoorports.dat       programs_bad.dat        rkhunter_prop_list.dat
i18n/                   rkhunter.dat            signatures/
mirrors.dat             rkhunter.dat.old        suspscan.dat


# rm -f /var/lib/rkhunter/db/rkhunter.data.old
# rm -f /var/lib/rkhunter/db/rkhunter.data
```

* Also, delete any temporary files
```
# rm -rf /var/lib/rkhunter/tmp/
```
* Now, recreate tmp folder and run rkhunter
```
# mkdir -p /var/lib/rkhunter/tmp
# rkhunter -c
```
If you don't create /var/lib/rkhunter/tmp/ folder, you may get error
```
Invalid TMPDIR configuration option: Non-existent pathname: /var/lib/rkhunter/tmp
```
Ref:
* How to create systemd timers - https://opensource.com/article/20/7/systemd-timers
