### Booting Raspberry Pi in single user mode 
Sometimes, you need to boot raspberry pi in single user mode as you did something wrong with the settings.

This allows you to get to a root shell by adding init=/bin/sh to /boot/cmdline.txt file. Further, sometimes file systems also gets corrupted. It is better to do fsck checks on the file systems.

File - /boot/cmdline.txt
You need to take out SD card and put it in another system. Once the disk is mounted, you need to append the following text to the existing line under /boot/cmdline.txt
```
fsck.repair=yes rootwait rw init=/bin/sh
```
and Reboot the original system again.

You can also do the same thing using NOOBS.

First you must hold the "Shift" key on Raspberry boot to get into NOOBS recovery section of the Raspberry
then you should add the following command at the end of the "cmdline.txt" :
```
init=/bin/sh
```
(do not remove or change any parts of the current commands in cmdline.txt at all)

click on Exit and let the raspberry getting restarted. Then you'll see the root shell but you can't still set a password for "root", because the directory of root config is in Read-only state. so you should firstly use the below command to mount and remount the OS Storage to renew write permission:

<device_block> = /dev/mmcblk0p7/
```
#mount -o remount,rw <device_block> 
```
```
# mount  <device_block>/boot
```
Now you can set a password for the root, using this command:
```
$ sudo passwd root
```
After setting a password for "root", Restart the raspberry, enter into Recovery mode again and remove the added command (init=/bin/sh) from "cmdline.txt", Exit and restart the Raspberry.

After loading the OS, open the command line and type "su" to get root access. now enter the password you've set for root user. after getting root access, enter the following commands to restore the corrupt "SUDO" permissions:
```
chown -R root:root /usr
```
### Issues in Single boot
As specified in many blogs, you need to modify file - ```cmdline.txt`` on boot partition and append the ```console``` line with a shell.
i.e. change  existing line
```
console=serial0,115200 console=tty1 root=PARTUUID=55f1e895-02 rootfstype=ext4 fsck.repair=yes rootwait
```
to
```
console=serial0,115200 console=tty1 root=PARTUUID=55f1e895-02 rootfstype=ext4 fsck.repair=yes rootwait rw init=/bin/sh
```
While editing on Windows, sometime, newline characters are introduced un-intentionally and you will be wondering why single boot is not effective. So, double check that ```rw init=/bin/sh``` is on single line!

* Sometimes, keyboard layout may get disturbed and as a result, the password set for 'pi' or other account may not work either locally or over ssh remote. In such a case, it's better to reconfigure the keyboard using
```
# dpkg-reconfigure keyboard-configuration
```

* If you have set password complexity requirements using PAM modules, you can comment out these lines under /etc/pam.d/common-password or any other files.

* In order to block brute force scanning attempts, fail2ban service is usually installed and this may create issues in debugging as you might be wondering why ```ssh`` for a remote machine is not happening. This is especially true if the keyboard layout or language options are changed during the setup.

#### Some interesting links
* https://medium.com/@tarilabs/reset-raspberry-pi-password-f5344c9850ec
* https://raspians.com/how-to-start-raspberry-pi-in-safe-mode/
* https://raspberrytips.com/forgot-raspberry-pi-password/

