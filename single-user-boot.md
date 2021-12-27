### Booting Raspberry Pi in single user mode 
Sometimes, you need to boot raspberry pi in single user mode as you did something wrong with the settings.

This allows you to get to a root shell by adding init=/bin/bash to /boot/cmdline.txt file. Further, sometimes file systems also gets corrupted. It is better to do fsck checks on the file systems.

File - /boot/cmdline.txt
You need to take out SD card and put it in another system. Once the disk is mounted, you need to append the following text to the existing line under /boot/cmdline.txt
```
fsck.repair=yes rootwait rw init=/bin/bash
```
and Reboot the original system again.

You can also do the same thing using NOOBS.

First you must hold the "Shift" key on Raspberry boot to get into NOOBS recovery section of the Raspberry
then you should add the following command at the end of the "cmdline.txt" :
```
init=/bin/bash
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
After setting a password for "root", Restart the raspberry, enter into Recovery mode again and remove the added command (init=/bin/bash) from "cmdline.txt", Exit and restart the Raspberry.

After loading the OS, open the command line and type "SU" to get root access. now enter the password you've set for root user. after getting root access, enter the following commands to restore the corrupt "SUDO" permissions:
```
chown -R root:root /usr
```

