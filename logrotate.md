### Setting up log roatation
Logrotate is a system utility that manages the automatic rotation and compression of log files. If log files were not rotated, compressed, and periodically pruned, they could eventually consume all available disk space on a system.

Logrotate is installed by default and and is set up to handle the log rotation needs of all installed packages, including rsyslog, the default system log processor.

### Important files/directories
* /etc/logrotate.conf: this file contains some default settings and sets up rotation for a few logs that are not owned by any system packages. It also uses an include statement to pull in configuration from any file in the /etc/logrotate.d directory.

* /etc/logrotate.d/: this is where any packages you install that need help with log rotation will place their Logrotate configuration. On a standard install you should already have files here for basic system tools like apt, dpkg, rsyslog and so on.

Typical /etc/logroate.conf file looks like this:
```
# see "man logrotate" for details
# rotate log files weekly
weekly

# keep 4 weeks worth of backlogs
rotate 4

# create new (empty) log files after rotating old ones
create

# uncomment this if you want your log files compressed
#compress

# RPM/deb packages drop log rotation information into this directory
include /etc/logrotate.d

# no packages own wtmp and btmp -- we'll rotate them here
/var/log/wtmp {
    monthly
    create 0664 root utmp
    minsize 1M
    rotate 1
}

/var/log/btmp {
    missingok
    monthly
    create 0600 root utmp
    rotate 1
}

# system-specific logs may be also be configured here.
```

Sometimes, the following settings are also applied:
```
 postrotate
                invoke-rc.d <daemon-name> reload >/dev/null 2>&1
        endscript
```
* Also, take care of journal activity size. Please refer to this link for more details - https://dev.to/brisbanewebdeveloper/amend-journal-has-been-rotated-since-unit-was-started-on-x1-extreme-gen-2-x1e2-5eme
