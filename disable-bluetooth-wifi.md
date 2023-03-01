Modules like Bluetooth, Ethernet and Wi-Fi are present on many Raspberry Pi device as they allow users to connect to the internet and perform different internet related activities. However, from security point of view, it's better to turn off un-used interfaces to minimize the attack surface.
### Disable Wi-Fi
There are different ways to disable Wi-Fi on Raspberry Pi board.
#### Disable Wi-Fi through configuration file "/boot/config.txt"
```
# use the -e option, it tells echo to evaluate backslash characters such as \n for new line
$ echo -e "[all]\n dtoverlay=disable-wifi" >> /boot/config.txt
```
#### Disable Wi-Fi through rfkill utility
"rfkill" command-line utility allows disabling of the network interface on Raspberry Pi system. To install, use
```
$ sudo apt install rfkill
```
Disable Wi-Fi using rfkill utility:
```
$ sudo rfkill block wifi
```
#### Disable Wi-Fi with Modprobe Blacklist
“Modprobe” is a software tool that allows access to kernel configuration files of Linux system. Using this feature, you can disable Wi-Fi:
```
echo -e "blacklist brcmfmac" >> /etc/modprobe.d/raspi-blacklist.conf
echo -e "blacklist brcmutil" >> /etc/modprobe.d/raspi-blacklist.conf
```
#### Disable Wi-Fi through systemctl
“wpa_supplicant” is service running on Raspberry Pi system that manages the Wi-Fi. Disabling this service through “systemctl” command will also disable the Wi-Fi on Raspberry Pi system.
```
$ sudo systemctl disable wpa_supplicant
```
### Disable bluetooth
List out bluetooth devices.
```
$ hcitool dev
```
Go through the "overlay" manual to inspect available options.

```
$ less /boot/overlays/README
```
```
[...]

Name:   disable-bt
Info:   Disable onboard Bluetooth on Pi 3B, 3B+, 3A+, 4B and Zero W, restoring
        UART0/ttyAMA0 over GPIOs 14 & 15.
        N.B. To disable the systemd service that initialises the modem so it
        doesn't use the UART, use 'sudo systemctl disable hciuart'.
Load:   dtoverlay=disable-bt
Params: <None>

[...]
```
Now, disable onboard bluetooth devices.
```
$ echo "dtoverlay=disable-bt" | sudo tee -a /boot/config.txt
```
or 
```
 # bluetooth (pi-4 or later)
$ echo "dtoverlay=disable-bt" >> /boot/config.txt
```
Disable systemd service that initializes Bluetooth Modems connected by UART and reboot
```
$ sudo systemctl disable hciuart
$ sudo reboot
```
Make sure that bluetooth devices are not listed.
```
$ hcitool dev
```


