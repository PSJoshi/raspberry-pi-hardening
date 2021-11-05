### Disable IPv6

* Check if ipv6 is enabled or not

```
# ifconfig |grep inet6
  inet6 addr: fe80::d6be:d9ff:fe99:5a77/64 Scope:Link
  inet6 addr: fe80::d6be:d9ff:fe99:5a77/64 Scope:Link
```
### Method: sysctl.conf
* To disable, append the following lines to /etc/sysctl.conf

```
# IPv6 support in the kernel, set to 0 by default
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```
To make the settings effective, execute:
```
# sysctl -p
# service procps force-reload
```
* Verify that IPv6 address does not show up in ifconfig. Restart the ethernet interface.
```
$ sudo ifconfig eth0 down && sudo ifconfig eth0 up
```
If you are doing these operations over SSH, the current session will be cut off. Be warned!! But, you should be able to reconnect in just a few seconds.
#### Method: Kernel Blacklisting
If your kernel was compiled with ipv6 support as a module, one possible way is to blacklist "ipv6" kernel module.
  * Create a file /etc/modprobe.d/blacklist.conf and add the following line:
    ```
      #Disabling IPv6
      blacklist ipv6
    ```
  * Create a file ipv6.conf under /etc/modprobe.d/ that contains the following line:
       ``` 
           install ipv6 /bin/true
        ```
  * Reboot to check if the modified settings are applied.


