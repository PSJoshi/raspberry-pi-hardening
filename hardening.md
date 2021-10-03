## Hardening Raspberry-Pi
The security of your Raspberry Pi is important. Raspberry Pi has been used in many applications - right from honeypots to smart homes and any gaps in its security will leave your Raspberry Pi open to hackers who can then use it without your permission.

So, it's important to harden the Raspberry Pi installation and keep it secure.

This hardening guide will cover the following aspects in Raspberry-Pi installation:
* Changing Users and/or its passwords
* Disabling un-used Interfaces
* SSH hardening
* Auto-update settings
* Firewall (iptables) hardening

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

#### References: 
* https://www.raspberrypi.org/documentation/computers/configuration.html#using-key-based-authentication
* https://www.raspberrypi.org/documentation/computers/remote-access.html#copy-your-public-key-to-your-raspberry-pi

Overall, please follow the detailed instructions at https://www.raspberrypi.org/documentation/computers/configuration.html#improving-ssh-security
