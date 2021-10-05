### Firewall setup
* Install iptables package
```
$ sudo apt install iptables
```
* Generate default configuration
```
$ sudo bash -c 'iptables-save > /etc/network/iptables.rules'
```
* Check rules
```
$ sudo iptables -nvL
```
* Load firewall configuration
```
$ sudo iptables-restore < /etc/network/iptables.rules
```
* Load everytime before network starts
For most cases, just enable the iptables service, or create a file /etc/network/if-pre-up.d/firewall with the content
```
#!/bin/sh
/sbin/iptables-restore < /etc/network/iptables.rules
```
Make the file executable
```
sudo chmod +x /etc/network/if-pre-up.d/firewall
```
