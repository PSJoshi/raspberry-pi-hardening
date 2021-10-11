### NTP time synchronization 
The Raspberry Pi OS version (lite or desktop) includes timedatectl by default. It’s a tool to manage the date and time on the Raspberry Pi.

Some useful commands to setup time synchronization are listed below:

* Current time 
```
$ timedatectl status
```
* List timezones
```
$ timedatectl list-timezones
```
* Set timezone
```
$ timedatectl list-timezones|grep asia -i|grep -i kol
$ timedatectl set-timezone Asia/Kolkata
```
* Disable time synchronization
Since our client will sync time with NTP server, disable timesyncd service on the client and setup your own ntp server and client.
```
$ sudo timedatectl set-ntp false
```
If you wish, you can also change the synchronization server:
```
$ sudo nano /etc/systemd/timesyncd.conf
```
Comment out last line and replace default server by your own server.

```
[Time]
#NTP=
#FallbackNTP=0.us.pool.ntp.org 1.us.pool.ntp.org
#FallbackNTP=ntp.ubuntu.com
#RootDistanceMaxSec=5
#PollIntervalMinSec=32
#PollIntervalMaxSec=2048
```
#### Ref: 
* https://raspberrytips.com/time-sync-raspberry-pi/
* https://rishabhdevyadav.medium.com/how-to-install-ntp-server-and-client-s-on-ubuntu-18-04-lts-f0562e41d0e1
* http://raspberrypi.tomasgreno.cz/ntp-client-and-server.html
