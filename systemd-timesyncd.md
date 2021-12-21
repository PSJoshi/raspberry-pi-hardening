### Time Synchronization using systemd-timesyncd service
 Systemd provides an easier way to keep time synchronized and you need not run ntp daemon to maintain time synchronization.
 There exists a built-in systemd-timesyncd service that does the basic time synchronization job just fine.
 However, I noticed that the daemon wasn't actually running on my system:
```
$ systemctl status systemd-timesyncd.service 
● systemd-timesyncd.service - Network Time Synchronization
   Loaded: loaded (/lib/systemd/system/systemd-timesyncd.service; enabled; vendor preset: enabled)
  Drop-In: /lib/systemd/system/systemd-timesyncd.service.d
           └─disable-with-time-daemon.conf
   Active: inactive (dead)
Condition: start condition failed at Thu 2017-08-03 21:48:13 PDT; 1 day 20h ago
     Docs: man:systemd-timesyncd.service(8)
referring instead to a mysterious "failed condition". Attempting to restart the service did provide more details though:
```
So, I attempted to restart the service and chekced its status.
```
$ systemctl restart systemd-timesyncd.service 
$ systemctl status systemd-timesyncd.service 
● systemd-timesyncd.service - Network Time Synchronization
   Loaded: loaded (/lib/systemd/system/systemd-timesyncd.service; enabled; vendor preset: enabled)
  Drop-In: /lib/systemd/system/systemd-timesyncd.service.d
           └─disable-with-time-daemon.conf
   Active: inactive (dead)
Condition: start condition failed at Sat 2017-08-05 18:19:12 PDT; 1s ago
           └─ ConditionFileIsExecutable=!/usr/sbin/ntpd was not met
     Docs: man:systemd-timesyncd.service(8)
```
The status lines indicate that the presence of /usr/sbin/ntpd points to a conflict between ntpd and systemd-timesyncd. The solution is to remove ntp before enabling the timesyncd:
```
$ sudo apt purge ntp
```
After the ntp package has been removed, it is time to enable NTP support in timesyncd.

Start by choosing the NTP server pool nearest to you and include it in /etc/systemd/timesyncd.conf. 
```
[Time]
#NTP=time.cloudflare.com
NTP=time.google.com
```
before restarting the daemon:
```
$ sudo systemctl restart systemd-timesyncd.service 
```
That's all. To check whether or not the time has been synchronized with NTP servers, run the following:
```
$ timedatectl
System clock synchronized: yes
NTP service: inactive
RTC in local TZ: no
```
If NTP is not enabled, then you can enable it by running this command:
```
$ sudo timedatectl set-ntp true
```

Once that's done, everything should be in place and time should be kept correctly:
```
$ timedatectl
System clock synchronized: yes
NTP service: active
RTC in local TZ: no
```

#### Ref:
* https://raspberrytips.com/time-sync-raspberry-pi/
* https://feeding.cloud.geek.nz/posts/time-synchronization-with-ntp-and-systemd/
