## rkhunter systemd services

rkhunter and its timer systemd services are given below:
A nice detailed description of various rkhunter options is available here:
https://x8t4.com/how-to-install-rkhunter-on-centos-7/

### rkhunter.service script
```
[Unit]
Description=Rootkit Scan

[Service]
Type=oneshot
ExecStartPre=/usr/bin/rkhunter --update --report-warnings-only
ExecStart=/usr/bin/rkhunter --cronjob --report-warnings-only
ExecStartPost=/usr/bin/rkhunter --propupd --report-warnings-only
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
[Unit]
Description=Daily Rootkit Scan

[Timer]
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
