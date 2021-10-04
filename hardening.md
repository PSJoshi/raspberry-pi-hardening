## Hardening Raspberry-Pi
The security of your Raspberry Pi is important. Raspberry Pi has been used in many applications - right from honeypots to smart homes and any gaps in its security will leave your Raspberry Pi open to malicious users who can then use it without your permission.

So, it's important to harden the Raspberry Pi installation and keep it secure.

This hardening guide will cover the following aspects in Raspberry-Pi installation:
* Changing Users and/or its passwords
* Disabling un-used Interfaces
* SSH hardening
* Auto-update settings
* Firewall (iptables) hardening
* Checking log files

And I will continue to add/modify this guide in due course as I become aware about the new security setting(s).

### Changing Users and/or its passwords
Pi comes with a default user and default password. The world knows about it. So, it's better to turn it off completely and create your own.
* Change password for user "pi": passwd (or during installation)
* Create new user and set password: 
```sudo adduser <user> ```
You will be prompted to set the password for <user> and the new user will have home directory at /home/<user>

* Set admin and/or sudo rights to new user:
``` 
 $ sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi <user>
```
Alternatively, you can also do:
 ```
 $ sudo /usr/sbin/useradd --groups sudo -m <user>
 ```
This will create a new account, create a directory for the account (such as /home/<user>), and add the new account to the sudo group so the user can use the sudo command. Once the new user account is created, it's required to set a password for the account.
 ```
 $ sudo passwd <user>
 ```
 
Check if sudo permissions are in place
```
$ sudo su - <user>
```
* Change to new user: 
``` su < user > ```
* Check for sudo-privileges: 
``` $ sudo su root ```
* Deactive password for user "pi": 
``` $ sudo passwd --lock pi ```
* Delete the pi user if you wish.
```
$ sudo deluser -remove-home pi
```
* Make sudo require password:
``` $ sudo visudo /etc/sudoers.d/010_pi-nopasswd ``` 
and change/add pi user entry as well as other <user> entry who have superuser rights:
```
    pi ALL=(ALL) PASSWD: ALL
    <user> ALL=(ALL) PASSWD: ALL
```
Save the file. It will be checked for any syntax errors. If no errors are detected, the file will be saved and a shell prompt will be returned.
* Reset the root password and set it to something hard to guess!
  ```
     $ sudo passwd root
   ```
* Create a new user for regular use and maintenance

Create a new user for regular use. The default “pi” user should only be used for upgrades or major changes.

To add a new user:
```
sudo adduser <user>
```

You will then be prompted to add a password for the new user and then hit enter.
The new user will have a home directory of /home/<user>/.

You need to give privileges to the new user to carry out routine tasks on Raspberry Pi. So, do this:
```
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi <user>
```
And check if it's working as expected:
```
sudo su - <user>
```
Refer to security section on Raspberry Pi site: https://github.com/raspberrypi/documentation/blob/develop/documentation/asciidoc/computers/configuration/securing-the-raspberry-pi.adoc

### Disabling un-used Interfaces
Most commonly, access to Raspberry Pi is done using Ethernet(wired) interface. Since Raspberry Pi supports many interfaces, it's better to turn them off if you are not going to use them. To do this, edit /boot/config.txt and add:
```
dtoverlay=disable-wifi
dtoverlay=disable-bt
``` 
Reference - https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README

### Auto-update Raspberry Pi OS
An up-to-date distribution contains all the latest security fixes, so it's ALWAYS better to update your Raspberry Pi to the latest version.

```
$ sudo apt update
$ sudo apt -y dist-upgrade
# for OS upgrade
$ sudo apt full-upgrade 
```
Although not related to seurity settings, its often required to search and purge packages for operational reasons. Some useful commands are documented here:
You can search for a package with the given keyword using apt-cache search.
```
$ sudo apt-cache search sl
```
You can view more information about a package before installing it with apt-cache show:
```
$ sudo apt-cache show sl
```
If you are not using PulseAudio for anything other than Bluetooth audio, remove it from the image by entering:
```
$ sudo apt -y purge "pulseaudio*"
```
* Its better to update Raspberry Pi OS as a part of cron job. The process for this is described below:

Create a file((bash script) ``` auto-update.sh ``` under /home/<user> and add the following

```
#!/bin/bash
sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt install openssh-server -y
sudo reboot
```
Make a log folder and add executable permission to the above script
```
$ mkdir -p log
$ sudo chmod +x auto-update.sh
```
Now, create cron job entry using a terminal and set the job to run for daily execution.
```
$ sudo crontab -e
```
Add the following line:
```
0 0 * * * /home/< user >/< file >.sh > /home/<user>/log/auto-update-cron.log 2>&1
```

### SSH hardening
SSH based access is the common way of accessing a Raspberry Pi device remotely. By default, logging with SSH requires you to enter a username/password and this password should be strong enough to avoid dictionary based attacks or its variants.

You can allow or deny specific user(s) access to Raspberry Pi by altering sshd configuration.
```
$ sudo vi /etc/ssh/sshd_config
```
Add, edit, or append to the end of the file the following line, which contains the usernames you wish to allow to log in:
```
AllowUsers <user-1> <user-2>
```
You can also use DenyUsers to specifically stop some usernames e.g. pi from logging in:
```
DenyUsers pi
```
After the change you will need to restart the sshd service using 
```
$ sudo systemctl restart ssh
$ sudo reboot
```
So the changes take effect as desired.

* If you wish, you can change SSH "Port 22" to something obscure like port in the range - 49152–65535 by doing modification in the file ``` /etc/ssh/sshd_config ```

* If SSH interface is not actived, it can be activated using 
```
$ sudo raspi-config 
#(select "Interfacing Options", "SSH" and enable it)
 ```
And restart SSH service.
```
$ sudo service ssh restart
```
* Typical, hardened sshd configuration looks like this:
 ```
 # Authentication:
 LoginGraceTime 120
 PermitRootLogin no
 StrictModes yes

 RSAAuthentication yes
 PubkeyAuthentication yes
 AuthorizedKeysFile %h/.ssh/authorized_keys

# To enable empty passwords, change to yes (NOT RECOMMENDED)
 PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
 # some PAM modules and threads)
 ChallengeResponseAuthentication no
 # Change to no to disable tunnelled clear text passwords
 PasswordAuthentication no

UsePAM no
  ```
* Go with key-based authentication instead of password whereever possible.
Key pairs cryptographically secure keys - One private, and the other one public. They can be used to authenticate a client to an SSH server (in this case the Raspberry Pi).
     
The client generates two keys, which are cryptographically linked to each other. The private key should never be released, but the public key can be freely shared. The SSH server takes a copy of the public key, and, when a link is requested, uses this key to send the client a challenge message, which the client will encrypt using the private key. If the server can use the public key to decrypt this message back to the original challenge message, then the identity of the client can be confirmed.

Generating a key pair in Linux is done using the ssh-keygen command on the client; the keys are stored by default in the .ssh folder in the user’s home directory. The private key will be called id_rsa and the associated public key will be called id_rsa.pub. 
By default, the key will be 2048 bits long: breaking the encryption on a key of that length would take an extremely long time, so it's considered to be very secure. You can make longer keys if the situation demands it. Note that you should only do the generation process once: if repeated, it will overwrite any previous generated keys. Anything relying on those old keys will need to be updated to the new keys.

You will be prompted for a passphrase during key generation - extra level of security measure and you can leave this blank.

The steps to generate key based authentication are elaborated below:

* Make sure to create .ssh folder with appropriate permissions:
```
 $ mkdir ~/.ssh
 $ chmod 0700 ~/.ssh
 $ touch ~/.ssh/authorized_keys
 $ chmod 0600 ~/.ssh/authorized_keys
```
* To generate new SSH keys enter the following command:
```
$ ssh-keygen
```
Upon entering this command, you will be asked where to save the key. It is suggested to save it in the default location (~/.ssh/id_rsa) by pressing Enter.
* Check directory contents of .ssh directory
```
$ ls ~/.ssh
```
You should see the files id_rsa and id_rsa.pub.
* Copy public key(id_rsa.pub) to Raspberry Pi.
```
$ ssh-copy-id <user>@<ip-address>
```
If ssh-copy-id command is not available, you can manually copy the file over ssh like this.
```
$ cat ~/.ssh/id_rsa.pub | ssh <USER>@<IP-ADDRESS> 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'

```
If you see the message ssh: connect to host <IP-ADDRESS> port 22: Connection refused and you know the IP-ADDRESS is correct, then you may not have enabled SSH on your Raspberry Pi. Run sudo raspi-config in the Pi’s terminal window, enable SSH, then try to copy the files again.

Further,check for errors under ``` /var/log/secure``` on Raspberry Pi.

If the log says Authentication refused: bad ownership or modes for directory /home/pi there is a permission problem regarding your home directory. SSH needs your home and ~/.ssh directory to not have group write access. You can adjust the permissions using chmod:
```
$ chmod g-w $HOME
$ chmod 700 $HOME/.ssh
4 chmod 600 $HOME/.ssh/authorized_keys
```
Finally, we need to disable password logins, so that all authentication is done only by the key pairs.

Edit ssh configuration file:
```
$ vi /etc/ssh/sshd_config
```
Modify the following settings in the file.
```
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
```
Save the file and restart ssh daemon.
```
$ sudo service ssh reload
$ sudo service ssh restart
```
#### References: 
* https://www.raspberrypi.org/documentation/computers/configuration.html#using-key-based-authentication
* https://www.raspberrypi.org/documentation/computers/remote-access.html#copy-your-public-key-to-your-raspberry-pi
     
### Firewall (iptables) hardening

Once you’ve locked down SSH, make sure that the iptables firewall is running on your Pi. Also, it's recommended to log the message whenever a firewall rule is activated and a connection is blocked.

* Install iptables
```
$ sudo apt-get install iptables iptables-persistent
```
Note that using the iptables firewall will require new kernel modules to be loaded. The easiest way to load them is to reboot your Pi. 

* List current firewall rules
```
$ sudo /sbin/iptables -L
```

* Save the firewall rules
You can save the rules to a text file and edit it using the command:
```
$ sudo /sbin/iptables-save > /etc/iptables/rules.v4
```

* Typical firewall rules look like this. You have to modify it to suit your configuration:
```
$ sudo cat /etc/iptables/rules.v4
 :INPUT ACCEPT [0:0]
 :FORWARD ACCEPT [0:0]
 :OUTPUT ACCEPT [0:0]

# Allows all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
 -A INPUT -i lo -j ACCEPT
 -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

# Accepts all established inbound connections
 -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allows all outbound traffic
 # You could modify this to only allow certain traffic
 -A OUTPUT -j ACCEPT

# Allows SSH connections
 # The --dport number is the same as in /etc/ssh/sshd_config
 -A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT

# log iptables denied calls (access via 'dmesg' command)
 -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

# Reject all other inbound - default deny unless explicitly allowed policy:
 -A INPUT -j REJECT
 -A FORWARD -j REJECT

COMMIT
```

Make sure that iptables are working properly. This can be tricky because you might be remotely connected via SSH, and if you’ve messed something up you don’t want your connection to be severed. 

There is a command that will help you by applying rules and asking for confirmation that you can still connect. If you don’t respond in a certain amount of time the program will assume you’ve gotten disconnected and it will roll back your changes. If you do respond, it will apply your changes permanently. To accomplish this use the command:
```
$ sudo /usr/sbin/iptables-apply /etc/iptables/rules.v4
```
If everything works, your changes will be applied and you can check them with the command:
```
$ sudo /sbin/iptables -L
```
### Check your logs regularly

Most of the attacks are visible in the log files. So, it's good to inspect them regularly.
Please check the following log files for the signs of suspicious activity:

* /var/log/syslog - Main log file for all services
* /var/log/message - System log file
* /var/log/auth.log - Authentication attempts are logged here.
* /var/log/mail.log - Traces of email logs
* Plus you can also watch other important services logs like apache (/var/log/apache2/error.log) and mysql(/var/log/mysql/error.log)

### Physical access protections
If your Raspberry Pi is accessbile physically to malicious user, make him/her hard to see the data.
* Auto logoff after X minutes
* Set Password for 'Grub' boot
* Encrypt data on SD card

### Block brute force attempts using Fail2ban
Fail2ban tool offers protection against brute-force attacks and automatically blocks the offending IPs. It saves you having to manually check log files for intrusion attempts and then update the firewall (via iptables) to prevent them.
* Install package
```
$ sudo apt install fail2ban
```
By default, it will ban attacker 10 minutes after 5 failures. You can also set your policies - configure number of tries before a ban, ban duration etc.
Main configuration file under /etc/fail2ban folder. Its mainly /etc/fail2ban/jail.conf
```
$ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
$ sudo nano /etc/fail2ban/jail.local
```
Add/modify the following section to the jail.local file. 
```
[ssh]
enabled  = true
port     = ssh
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 6
```
The above configuration examines the ssh port, filters using the sshd parameters, parses the /var/log/auth.log for malicious activity, and allows six retries before the detection threshold is reached. Checking the default section, we can see that the default banning action
```
 Default banning action (e.g. iptables, iptables-new,
# iptables-multiport, shorewall, etc) It is used to define
# action_* variables. Can be overridden globally or per
# section within jail.local file
banaction = iptables-multiport
```
iptables-multiport means that the Fail2ban system will run the /etc/fail2ban/action.d/iptables-multiport.conf file when the detection threshold is reached. There are a number of different action configuration files that can be used. Multiport bans all access on all ports.
If you want to permanently ban an IP address after three failed attempts, you can change the maxretry value in the [ssh] section, and set the bantime to a negative number:
```
[ssh]
enabled  = true
port     = ssh
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 3
bantime = -1
```

* Restart the service after you made the changes
```
$ sudo service fail2ban restart
```
### Stop un-necessary services
Take a review of all the services running on the device. If a particular service is not required, it's better to turn it off. By doing this, you are automatically reducing the attack surface of the device.
* To stop service
```
$ sudo service <service-name> stop
```
If the service starts automatically on boot, use
```
$ sudo update-rc.d <service-name> remove
```
* To uninstall the service
```
$ sudo apt remove <service-name>
```

### Do not allow autologins and empty passwords
Make sure that nobody uses empty passwords for accessing Raspberry Pi.
* Search /etc/shadow file for empty passwords.
```
$ sudo awk -F: '($2 =="") {print} /etc/shadown
```
* lock unsafe accounts
```
$ passwd -l <user>
```
* Disable autologin feature
```
$ sudo sed -i 's/^greeter-hide-users=true/greeter-hide-users=false/g' /etc/lightdm/lightdm.conf
$ sudo sed -i 's/^\#greeter-allow-guest=true/greeter-allow-guest=false/g' /etc/lightdm/lightdm.conf
$ sudo sed -i 's/^\#greeter-show-manual-login=false/greeter-show-manual-login=true/g' /etc/lightdm/lightdm.conf
$ sudo sed -i 's/^\#allow-guest=true/allow-guest=false/g' /etc/lightdm/lightdm.conf
$ sudo sed -i 's/^\#allow-guest=true/allow-guest=false/g' /etc/lightdm/lightdm.conf
$ sudo sed -i 's/^\#autologin-user-timeout=0/autologin-user-timeout=10/g' /etc/lightdm/lightdm.conf
# also comment out default login from 'pi'
$ sudo sed -i 's/^autologin-user=pi/\#autologin-user=pi/g' /etc/lightdm/lightdm.conf
```
### Unattended Upgrade
* Install unattended-upgrades package from the repository.
```
$ sudo apt install unattended-upgrades
```
Customize the configuration file /etc/apt/apt.conf.d/50unattended-upgrades as per your preferences.

Next do the following configuration changes in "periodic upgrade" file - /etc/apt/apt.conf.d/02periodic
```
APT::Periodic::Enable "1";
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "1";
APT::Periodic::Verbose "2";
```  
If the file is empty, add the above lines. If not, modify the settings as per your preferences.

The above setting will enable automatic update every day.

You can debug the configuration with the command:
```
$ sudo unattended-upgrades -d
```
### Sysctl.conf Hardening
"/etc/sysctl.conf" file is used to configure kernel parameters at runtime. Linux reads and applies settings from this file.

The following settings available in /etc/sysctl.conf will help you to improve security:

* Limit network-transmitted configuration for IPv4
* Limit network-transmitted configuration for IPv6
* Turn on execshield protection
* Prevent against the common 'syn flood attack'
* Turn on source IP address verification
* Prevents a cracker from using a spoofing attack against the IP address of the server.
* Logs several types of suspicious packets, such as spoofed packets, source-routed packets, and redirects.

```
$ sudo nano /etc/sysctl.conf

# IP Spoofing protection
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
# Block SYN attacks
net.ipv4.tcp_syncookies = 1
# Controls IP packet forwarding
net.ipv4.ip_forward = 0
# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
# Log Martians
net.ipv4.conf.all.log_martians = 1
# Block SYN attacks
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5
# Log Martians
net.ipv4.icmp_ignore_bogus_error_responses = 1
# Ignore ICMP broadcast requests
net.ipv4.icmp_echo_ignore_broadcasts = 1
# Ignore Directed pings
net.ipv4.icmp_echo_ignore_all = 1
kernel.exec-shield = 1
kernel.randomize_va_space = 1
# disable IPv6 if not required
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
# Accept Redirects? No, this is not router
net.ipv4.conf.all.secure_redirects = 0
# Log packets with impossible addresses to kernel log? yes
net.ipv4.conf.default.secure_redirects = 0
# [IPv6] Number of Router Solicitations to send until assuming no routers are present.
# This is host and not router.
net.ipv6.conf.default.router_solicitations = 0
# Accept Router Preference in RA?
net.ipv6.conf.default.accept_ra_rtr_pref = 0
# Learn prefix information in router advertisement.
net.ipv6.conf.default.accept_ra_pinfo = 0
# Setting controls whether the system will accept Hop Limit settings from a router advertisement.
net.ipv6.conf.default.accept_ra_defrtr = 0
# Router advertisements can cause the system to assign a global unicast address to an interface.
net.ipv6.conf.default.autoconf = 0
# How many neighbor solicitations to send out per address?
net.ipv6.conf.default.dad_transmits = 0
# How many global unicast IPv6 addresses can be assigned to each interface?
net.ipv6.conf.default.max_addresses = 1

# In rare occasions, it may be beneficial to reboot your server reboot if it runs out of memory.
# This simple solution can avoid you hours of down time. The vm.panic_on_oom=1 line enables panic
# on OOM; the kernel.panic=10 line tells the kernel to reboot ten seconds after panicking.
vm.panic_on_oom = 1
kernel.panic = 10

# Apply new settings
sudo sysctl -p
```

### Set hostname 
The hostname uniquely identifies your computer on the local network. The hostname can be use in many services or applications. Once the hostname is set, it is not recommended to change it.
```
$ sudo nano /etc/hostname
<ip/hostname>

$ sudo nano /etc/hosts
127.0.0.1	localhost localhost.localdomain <ip/hostname>

```
### Set Locale and Timezone
* set language
```
sudo locale-gen en_GB.UTF-8
sudo update-locale LANG=en_GB.UTF-8
sudo dpkg-reconfigure tzdata
```
* Display and set the current system’s time and timezone

```
# display current settings
$ timedatectl

# display time zones
$ timedatectl list-timezones

# set timezone
$ sudo timedatectl set-timezone your_time_zone
```
### Setting security limits

```/etc/security/limits.conf``` allows setting resource limits for users logged in via PAM. These settings are useful to protect your system against fork bomb attacks, resource exhaustion etc.
* core
Corefiles are useful for debugging, but annoying when normally using your system. You should have a soft limit of 0 and a hard limit of unlimited, and then temporarily raise your limit for the current shell with ulimit -c unlimited when you need corefiles for debugging.
```
*           soft    core       0           # Prevent corefiles from being generated by default.
*           hard    core       unlimited   # Allow corefiles to be temporarily enabled. 
```
* nice
You should disallow everyone except for root from having processes of minimal niceness (-20), so that root can fix an unresponsive system.
```
*           hard    nice       -19         # Prevent non-root users from running a process at minimal niceness.
root        hard    nice       -20         # Allows root to run a process at minimal niceness to fix the system when unresponsive.
```
* nofile
This limits the number of file descriptors any process owned by the specified domain can have open at any one time. You may need to increase this value to something as high as 8192 for certain applications to work. Some database applications like MongoDB or Apache Kafka recommend setting nofile to 64000 or 128000.
```
*           hard    nofile     8192   # Raise this value in case you are running ElasticSearch/Kafka/MongoDB
```
* nproc
Having an nproc limit is important, as this will limit how many times a fork-bomb can replicate. However, having it too low can make your system unstable or even unusable, as new processes will not be able to be created.

A value of 300 is too low for even the most minimal of Window-managers to run more than a few desktop applications and daemons, but is often fine for an X-less server!
```
*           hard    nproc      2048        # Prevent fork-bombs from taking out the system.
```
Note that this value of 2048 is just an example, and you may need to set yours higher. On the flipside, you also may be able to do with it being lower.
* priority
The default niceness should generally be 0, but you can set individual users and groups to have different default priorities using this parameter.
```
*           soft    priority   0           # Set the default priority to neutral niceness.
```

### Bash shell hardening
* In /etc/profile, defind HISTTIMEFORMAT variable
```
export HISTTIMEFORMAT="%d/%m/%y %T "
```
* Make bash_history append only
```
$ sudo chattr +a /home/<user>/.bash_history
```

* Harden bash history related environment variables by adding the following lines
to .bashrc of each user (/home/<user>/.bashrc)

```
shopt -s histappend 
readonly PROMPT_COMMAND="history -a" 
readonly HISTFILE 
readonly HISTFILESIZE 
readonly HISTSIZE 
readonly HISTCMD 
readonly HISTCONTROL 
readonly HISTIGNORE
```
Further, change the owner of all bash related files to root and give user(s) only read access.
```
$ sudo chown root /home/$USER/.bash_history 
$ sudo chown root /home/$USER/.bash_profile 
$ sudo chown root /home/$USER/.bash_login
$ sudo chown root /home/$USER/.profile
$ sudo chown root /home/$USER/.bash_logout
$ sudo chown root /home/$USER/.bashrc

$ sudo chmod o+rwt     /home/$USER/.bash_history 
$ sudo chmod o+rt,a+x  /home/$USER/.bash_profile 
$ sudo chmod o+rt,a+x  /home/$USER/.bash_login
$ sudo chmod o+rt,a+x  /home/$USER/.profile
$ sudo chmod o+rwt,a+x /home/$USER/.bash_logout
$ sudo chmod o+rwt,a+x /home/$USER/.bashrc

$ sudo chattr +a /home/$USER/.bash_history 
$ sudo chattr +a /home/$USER/.bash_logout
$ sudo chattr +a /home/$USER/.bashrc
```

You can also make use of this nice bash hardening script. Kindly tune it to your preferences: 
```
echo ">>> Starting"
echo ">>> Loading configuration into /etc/bash.bashrc"

echo "HISTTIMEFORMAT='%F %T '" >> /etc/bash.bashrc
echo 'HISTFILESIZE=-1' >> /etc/bash.bashrc
echo 'HISTSIZE=-1' >> /etc/bash.bashrc
echo 'HISTCONTROL=ignoredups' >> /etc/bash.bashrc

# Custom history configuration
echo '# Configure BASH to append (rather than overwrite the history):' >> /etc/bash.bashrc
echo 'shopt -s histappend' >> /etc/bash.bashrc

echo '# Attempt to save all lines of a multiple-line command in the same entry' >> /etc/bash.bashrc
echo 'shopt -s cmdhist' >> /etc/bash.bashrc

echo '# After each command, append to the history file and reread it' >> /etc/bash.bashrc
# echo 'export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a; history -c; history -r"' >> /etc/bash.bashrc
echo 'export PROMPT_COMMAND="history -a"'>> /etc/bash.bashrc
# Reload BASH for settings to take effect
echo ">>> Reloading BASH"
exec "$BASH"

echo ">>> Finished. Exiting."
```
References:
* https://www.thomaslaurenson.com/blog/2018-07-02/better-bash-history/
* Shell history file for each user - https://unixhealthcheck.com/blog?id=251
 
Overall, please follow the detailed instructions at https://www.raspberrypi.org/documentation/computers/configuration.html#improving-ssh-security

### Operational commands
* List all running services
```
$ sudo service --status-all
```
* Automatically start service on boot
```
$ sudo update-rc.d ssh defaults
```
* Remove service from automatic start
```
$ sudo update-rc.d -f ssh remove
```

 
### Interesting links:
* How to prepare Raspberry Pi for first time - https://reelyactive.github.io/diy/pi-prep/
* Readonly Raspberry Pi (Arch linux) - https://gist.github.com/fmarcia/f96df1a3afadb51637b0
