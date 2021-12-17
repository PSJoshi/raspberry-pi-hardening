### Systemd services hardening
Systemd provides options to harden systemd-service. You can analyze the status using
```
# systemd-analyze security
```
For specific service-e.g. dbus, you can use
```
# systemd-analyze security dbus.service
```
To harden it, you need to override default systemd options.
```
# systemctl edit dbus.service
```
Add the following
```
Requires=dbus.socket

[Service]
Type=notify
NotifyAccess=main
ExecStart=@EXPANDED_BINDIR@/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
CapabilityBoundingSet=CAP_SETGID CAP_SETUID CAP_SETPCAP
DeviceAllow=/dev/null rw
DeviceAllow=/dev/urandom r
DevicePolicy=strict
ExecReload=@EXPANDED_BINDIR@/dbus-send --print-reply --system --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig
ExecStart=@EXPANDED_BINDIR@/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
IPAddressDeny=any
LimitMEMLOCK=0
LockPersonality=yes
MemoryDenyWriteExecute=yes
NoNewPrivileges=yes
NotifyAccess=main
OOMScoreAdjust=-900
PrivateDevices=yes
PrivateTmp=yes
ProtectControlGroups=yes
ProtectHome=yes
ProtectKernelModules=yes
ProtectKernelTunables=yes
ProtectSystem=strict
ReadOnlyPaths=-/
RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6 AF_PACKET AF_NETLINK
RestrictNamespaces=yes
RestrictRealtime=yes
SystemCallArchitectures=native
SystemCallFilter=@system-service
SystemCallFilter=~@chown @clock @cpu-emulation @debug @module @mount @obsolete @raw-io @reboot @resources @swap memfd_create mincore mlock mlockall personality
Type=notify
UMask=0077
```
You have to repeat this procedure carefully for all the systemd services.

#### Some useful systemd commands

| command | description |
| -------- | ---------- |
| systemctl list-dependencies | show unit's dependencies |
| systemctl list-sockets | list sockets |
| systemctl list-jobs | view active systemd jobs |
| systemctl list-unit-files | see unit files |
| systemctl list-units | show loaded units |
| systemctl get-default | list default target |


### References
* https://www.freedesktop.org/software/systemd/man/systemd.exec.html#CapabilityBoundingSet=
* https://gist.github.com/ageis/f5595e59b1cddb1513d1b425a323db04
* https://www.linode.com/docs/guides/introduction-to-systemctl/
* http://0pointer.de/blog/projects/security.html
* https://info.tail-f.com/hubfs/Whitepapers/Tail-f%20Securing%20and%20Sandboxing%20ConfD_Rev%20B_2020-11-17.pdf
