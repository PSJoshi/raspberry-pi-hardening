## Default raspberry pi files with SUID and SGID permissions

### Files with setuid bit(-rwsr-xr-x)
```
# chmod u+s /bin/fusermount
# chmod u+s /bin/mount
# chmod u+s /bin/ping
# chmod u+s /bin/su
# chmod u+s /bin/umount
# chmod u+s /bin/ntfs-3g

# chmod u+s /usr/bin/bsd-write
# chmod u+s /usr/bin/bwrap
# chmod u+s /usr/bin/chfn
# chmod u+s /usr/bin/chsh
# chmod u+s /usr/bin/gpasswd
# chmod u+s /usr/bin/newgrp
# chmod u+s /usr/bin/passwd
# chmod u+s /usr/bin/pkexec
# chmod u+s /usr/bin/sudo

# chmod u+s /usr/sbin/exim4
# chmod u+s /sbin/mount.cifs
# chmod u+s /sbin/mount.nfs
# chmod u+s /sbin/mount.nfs
```
### Files with setgid bit (-rwxr-sr-x)
```
# chmod g+s /sbin/unix_chkpwd
# chmod g+s /usr/bin/bsd-write
# chmod g+s /usr/bin/chage
# chmod g+s /usr/bin/crontab
# chmod g+s /usr/bin/dotlock.mailutils
# chmod g+s /usr/bin/dotlockfile
# chmod g+s /usr/bin/expiry
# chmod g+s /usr/bin/ssh-agent
# chmod g+s /usr/bin/wall
```

### Set sticky bit for /tmp
```
# chmod +t /tmp
```
