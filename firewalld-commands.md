### Linux firewall rules 
As everyone knows, iptables is a de-facto tool for managing firewall rules on a Linux machine.In the recent past, firewalld is also becoming a popular tool for managing firewall rules on a Linux machine.

Apart from firewalld, there are other tools out there - ufw, nftables to make life of system admins easier!

It all starts with Netfilter, which controls access to and from the network stack at the Linux kernel module level. For decades, the primary command-line tool for managing Netfilter hooks was ```iptables``` ruleset.

Since the syntax needed to invoke these rules is a bit arcane, various user-friendly implementations like ufw and firewalld were introduced as higher-level Netfilter interpreters. ```ufw``` and ```firewalld``` are designed to solve problems in stand-alone PC/server. But, if you wish to deploy firewall rules across organization on many servers on different network segments, you need to build a full-sized network solutions using iptables (it's a bit tricky!). So its replacement, ```nftables``` is becoming popular! ```nftables``` has brought some important new functionality by adding on to the classic Netfilter toolset.

But,```iptables``` is still widely used and you will continue to see iptables-protected networks for many years to come.  

Some commonly used ```firewalld commands are listed below:

* Firewall version
```
# firewall-cmd -V
```
* Current state of firewall
```
# firewall-cmd --state
```

* Check all the allowed services for the default zone through firewall
```
# firewall-cmd --list-services
```
* check all the allowed ports through firewall zones 
```
# firewall-cmd --list-ports
```
* Check current active zones and interfaces associated with active zone
```
# firewall-cmd --get-active-zones
```
* check the log denied setting option
```
# firewall-cmd --get-log-denied
```
* check current automatic helper setting
firewalld helper defines the configuration that are needed to be able to use a netfilter connection tracking helper if automatic helper assignment is turned off, which is then the secure use of connection tracking helpers. As you can see from output, current automatic helpers is set to System.
```
# firewall-cmd --get-automatic-helpers
system
```
* If you think that there is some serious problem going in your network where you want to expire all active connections and stop all incoming and outgoing traffic then you need to use --panic-on firewall
```
# firewall-cmd --panic-on
```
* Check if panic mode is enabled or not
```
# firewall-cmd --query-panic
```
* Create new zone
If you want to create a permanent zone then you need to use --new-zone=<zone_name> option
```
# firewall-cmd --permanent --new-zone=private
```
Check information about the zone
```
# firewall-cmd --permanent --info-zone=private
```
* Get public zone information
```
# rewall-cmd --permanent --info-zone=public
```
* Delete zone
```
# firewall-cmd --permanent --delete-zone=private
```
* Enable lockdown option for firewall
Applications running in your system with root access sometime might be able to change the firewall configuration so to stop applications from doing that you can enable lockdown by using --lockdown-on option with firewall cmd command.
```
# firewall-cmd --lockdown-on
```
You can query lockdown state using
```
# firewall-cmd --query-lockdown
```
You can also disable lockdown using
```
# firewall-cmd --lockdown-off
```
* Reload firewall rules and configuration
```
# firewall-cmd --reload
```
To completely reload the firewall rules and configuration along with netfilter kernel modules, use the following command:
```
# firewall-cmd --complete-reload
```
