### Setting up firewall rules on Raspberry Pi
* Install iptables-persistent package with apt-get command
```
# apt-get install iptables-persistent
```
* Add iptable rules to ```/etc/iptables/rules.v4``` file.

* Check existing iptables rules
```
# # iptables -nLv
```
* Save rules to ```/etc/iptables/rules.v4``` file
```
# /sbin/iptables-save > /etc/iptables/rules.v4
```
