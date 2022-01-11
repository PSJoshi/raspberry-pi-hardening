### auth.log 
#!/bin/bash
$ sudo grep "user root" /var/log/auth.log
$ sudo cat /var/log/auth.log | grep 'Invalid user'
$ sudo grep "authentication failure" /var/log/auth.log | cut -d '=' -f 8 root
