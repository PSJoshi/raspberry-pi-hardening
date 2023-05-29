There is need to prepare a custom layout paritition(s) for fulfiling CIS security benchmark requirements.
By default, Raspberry Pi image contains only two partitions - boot and root (sometimes root partition is not extended to utilize full capacity of the disk. In the latest distribution, this is now handled as a part of rasp-config utility)
CIS benchmark demands that partitions like /home/, /var, /var/log should be on seperate paritions and be different from /root. So, in this guide, we’re going to setup a Micro SD card with a fresh boot partition for the Raspberry Pi from scratch. We are not using an ready-made raspberry-pi image and we are not using the expansion feature.

Make sure that destination SD card is empty. If it isn’t, you’ll need to delete all the partitions using “fdisk /dev/device”, and then deleted them with “d”

Or
You can delete existing partitions with the following command.
```
# dd if=/dev/zero of=/dev/DEVICE bs=512 count=1
```
Replace “/dev/DEVICE” with the actual device label for the card. Note that this will render existing data useless and unrecoverable. Kindly unplug and re-insert the SD card.

### Creating the layout
On an empty Micro SD card:
```
fdisk /dev/<device>
```
* Open fdisk on your card.
```fdisk /dev/<device>
```
* Press “n” to create a partition.
* Press “p” to make it a primary partition.
* Press “1” to make it the first partition in the table.
* Press <enter> to accept the default on start sector.
* Type +size to choose the size. In my case I want 1GB, so I’ll type “+1G”.
* After it’s created, press “a” to make it bootable.
* Now we press “p” to print and view the partition table, as shown below.

* Now we need to set the partition type. Press “t” to set a partition type, choose the partition, and type “c” for “W95 FAT32 (LBA)”. We’re now left with this partition table.

* Press “w” to write and save, and exit fdisk.
* We now need to format the partition. Run the following command on your device.
```
# mkfs.vfat /dev/<device>
```
Finally, you can now set a label to the partition. Ubuntu uses the label “system-boot” whereas Raspbian uses “boot”. You can set it with the following command:
```
# fatlabel /dev/<device> NEW_LABEL
```
You now have a clean partition layout that can be used to boot a Raspberry Pi. Remember that this is just the partition layout and the files are still needed from an image or your current running instance. These can simply be copied over.


### References
* https://www.i-programmer.info/programming/hardware/7688-real-raspberry-pi-custom-noobs.html?start=1
* Raspberry Pi documentation - https://github.com/raspberrypi/documentation/tree/develop/documentation
* Raspberry Pi mode OTG mode - https://gist.github.com/hbcbh1999/ff466ffa27e9f16a9e30
