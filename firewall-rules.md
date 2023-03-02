### Setting up firewall rules
* Install ```iptables-persistent``` package using ```apt``` package manager:
```
$ sudo apt install iptables-persistent
```
Note:
* Deb distribution - ```iptables-persistent``` package
* RPM distribution - ```iptables-services``` package

Make iptable rules persistent using ```iptables-save``` command even after reboot

* Any current iptables rules will be saved to the corresponding IPv4 and IPv6 files below:
```
/etc/iptables/rules.v4
/etc/iptables/rules.v6
```
* See existing iptable rules
```
$ sudo iptables -L
```
* To update persistent iptables with new rules, use ```iptables``` command to include new rules into the system. To make changes permanent after reboot, run ```iptables-save``` command:
```
$ sudo iptables-save > /etc/iptables/rules.v4
```
* To remove persistent iptables rules, open ```/etc/iptables/rules.v4``` file and delete lines containing all unwanted rules.
