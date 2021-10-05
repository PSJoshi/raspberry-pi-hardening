### Setting up Raspberry Pi
* Download raspbian OS from https://www.raspberrypi.org/downloads/raspbian/
* Install to SD card
```
diskutil list
diskutil unmountDisk /dev/disk<#>
sudo dd bs=1m if=<image.img> of=/dev/rdisk<#> conv=sync
sudo diskutil eject /dev/rdisk<#>
```
* Enable ssh on SD card
```
touch ssh /root
```
* Update Raspberry Pi
```
rpiupdate
apt-get full-upgrade
```
