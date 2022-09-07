### Fail2ban
Fail2ban is very powerful log-parsing application that monitor system logs and recognize signs that indicate automated attacks on the system.
When Fail2ban identifies an attempted compromise using your custom parameters, it will add a new rule to iptables to block the 
IP address from which the attack originates. This restriction will stay in effect for a specific length of time as per configuration.
You can also set your Fail2ban configuration to ensure that you are notified of attacks via email.
While Fail2ban is mainly designed for SSH attacks, you can also experiment with Fail2ban configuration to suit any service that 
utilizes log files and is at potential risk of being compromised.


```
# yum install epel-release -y
# yum install fail2ban -y
# sudo systemctl enable fail2ban
# cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

```
You can modify the configuration parameters in default section of /etc/fail2ban/fail2ban.local as per your requirements.
```
[Default]
# can be changed to ERROR/DEBUG etc. Check python logging levels
loglevel = INFO
logtarget = STDERR
socket = /var/run/fail2ban/fail2ban.sock
pidfile = /var/run/fail2ban/fail2ban.pid
# Notes.: Sets age at which bans should be purged from the database
# Values: [ SECONDS ] Default: 86400 (24hours)
dbpurgeage = 1d
#file for persistent data storage
dbfile = /var/lib/fail2ban/fail2ban.sqlite3
ignoreip = 127.0.0.1/8

```
Fail2ban is mainly used to protect ssh port from brute force attacks. To configure ssh, you modify the file as
```
# cat > /etc/fail2ban/jail.d/sshd.local << "EOF"
[sshd]
enabled = true
port = 22
maxretry = 3
findtime = 600
bantime = 3600
"EOF"
```
Now restart the fail2ban daemon and check its status
```
# systemctl restart fail2ban
# systemctl status fail2ban
```

If you want to look at your Fail2ban rules, use the iptables’ –line-numbers option.
```
# iptables -L f2b-sshd -v -n --line-numbers
```
To check that the Fail2Ban is operating and the SSHd jail has been enabled, use the following command:
```
# fail2ban-client status
# fail2ban-client status sshd
```
### Script to add/modify settings in ```jail.local``` file
```
#!/bin/bash

result=$(cat /etc/fail2ban/jail.local |grep -i "^loglevel")
if [[ ! -z $result ]]; then
    sed -i -e "/^\[DEFAULT/{n;/^loglevel/s/=.*/=DEBUG/;}" /etc/fail2ban/jail.local
else
 sed -i -e "/^\[DEFAULT\]/a\loglevel=INFO" /etc/fail2ban/jail.local
fi

result=$(cat /etc/fail2ban/jail.local |grep -i "^logtarget")
if [[ ! -z $result ]]; then
    sed -i -e "/^\[DEFAULT/{n;/^logtarget/s/=.*/=STDERR/;}" /etc/fail2ban/jail.local
else
    sed -i -e "/^\[DEFAULT\]/a\logtarget=STDERR" /etc/fail2ban/jail.local
fi

result=$(cat /etc/fail2ban/jail.local |grep -i "^pidfile")
if [[ ! -z $result ]]; then
    sed -i -e "/^\[DEFAULT/{n;/^pidfile/s/=.*/=\/var\/run\/fail2ban\/fail2ban.pid/;}" /etc/fail2ban/jail.local
else
    sed -i -e "/^\[DEFAULT\]/a\pidfile=/var/run/fail2ban/fail2ban.pid" /etc/fail2ban/jail.local
fi

result=$(cat /etc/fail2ban/jail.local |grep -i "^socket")
if [[ ! -z $result ]]; then
    sed -i -e "/^\[DEFAULT/{n;/^socket/s/=.*/=\/var\/run\/fail2ban\/fail2ban.sock/;}" /etc/fail2ban/jail.local
else
    sed -i -e "/^\[DEFAULT\]/a\socket=/var/run/fail2ban/fail2ban.sock" /etc/fail2ban/jail.local
fi

result=$(cat /etc/fail2ban/jail.local |grep -i "^dbpurgeage")
if [[ ! -z $result ]]; then
    sed -i -e "/^\[DEFAULT/{n;/^dbpurgeage/s/=.*/=1d/;}" /etc/fail2ban/jail.local
else
    sed -i -e "/^\[DEFAULT\]/a\dbpurgeage=1d" /etc/fail2ban/jail.local
fi

result=$(cat /etc/fail2ban/jail.local |grep -i "^dbfile")
if [[ ! -z $result ]]; then
    sed -i -e "/^\[DEFAULT/{n;/^dbfile/s/=.*/=\/var\/lib\/fail2ban\/fail2ban.sqlite3/;}" /etc/fail2ban/jail.local
else
    sed -i -e "/^\[DEFAULT\]/a\dbfile=/var/lib/fail2ban/fail2ban.sqlite3" /etc/fail2ban/jail.local
fi

# for CentOS system, it may be changed to systemd instead of auto option.
#result=$(cat /etc/fail2ban/jail.local |grep -i "^backend")
#if [[ ! -z $result ]]; then
#    sed -i -e "/^\[DEFAULT/{n;/^backend/s/=.*/=systemd/;}" /etc/fail2ban/jail.local
#else
#    sed -i -e "/^\[DEFAULT\]/a\backend=systemd" /etc/fail2ban/jail.local
#fi
```
#### References:
* https://linuxhandbook.com/fail2ban-basic/
* https://www.plesk.com/blog/various/using-fail2ban-to-secure-your-server/
* * https://blog.zimbra.com/2022/08/configuring-fail2ban-on-zimbra/
