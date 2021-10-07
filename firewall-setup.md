### Firewall setup
IPtables is de-facto firewall available in all linux distributions. As a good security practice, the firewall MUST be enabled and properly configured.

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
In firewall, there are 3 chains:
* INPUT - Used to control the behavior of INCOMING connections.
* FORWARD - Used to control the behavior of connections that aren't delivered locally but sent immediately out. (i.e.: router)
* OUTPUT - Used to control the behavior of OUTGOING connections.

Many connections/protocols require inbound and outbound rules.
* Chain policy 
Current policy
```
sudo iptables -L |grep policy
```
To change the default policy of a chain, run: `iptables --policy <ACCEPT/DROP>
```
iptables --policy INPUT ACCEPT
iptables --policy OUTPUT ACCEPT
iptables --policy FORWARD ACCEPT
```

* Actions: ACCEPT vs DROP vs REJECT

ACCEPT: Allow the connection
DROP: Drop the connection (as if no connection was ever made; Useful if you want the system to 'disappear' on the network)
REJECT: Don't allow the connection but send an error back.

* Accept connection from single IP
```
$ iptables -A INPUT -s 10.10.10.2 -j ACCEPT

# Explanation: 
# ACCEPTS all INCOMING Connections from 10.10.10.2
# -A <CHAIN>  : Append a Rule to the chain that is specified (INPUT in this scenario)
# -s <SOURCE> : Source - The Source IP of the connection (10.10.10.2)
# -j <ACTION> : (jump) - Defines what to do when the Packet matches this rule. We can either ACCEPT, DROP or REJECT it. (ACCEPT)
```

* Drop connections for IP range
```
$ iptables -A INPUT -s 10.10.10.0/24 -j DROP
```
* REJECT OUTBOUND Connections for an IP on a Specific Port (SSH)
```
$ iptables -A OUTPUT -p tcp --dport ssh -s 10.10.10.10 -j REJECT
```
* Flush iptable rules
To clear all the rules that are configured, you can flush it with the Flush command.
```
$ iptables -F
```
* List all active rules
```
$ iptables -L
$ iptables -L --line-numbers
```
* Remove a specific rule by its line number
```
iptables -D INPUT 1
```
* Allow local connections (loopback)
```
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
```
* Allow incoming connection on port X
```
iptables -A INPUT -i eth0 -p tcp --dport X -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport X -m state --state ESTABLISHED -j ACCEPT
```

* Allow incoming connection on multiple ports X,Y,Z
```
iptables -A INPUT -i eth0 -p tcp -m multiport --dports X,Y,Z -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports X,Y,Z -m state --state ESTABLISHED -j ACCEPT
```

* Allow outgoing connections on port X
```
iptables -A OUTPUT -o eth0 -p tcp --dport X -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport X -m state --state ESTABLISHED -j ACCEPT
```

* Allow outgoing connections on multiple ports X,Y,Z
```
iptables -A OUTPUT -o eth0 -p tcp -m multiport --dports X,Y,Z -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m multiport --sports X,Y,Z -m state --state ESTABLISHED -j ACCEPT
```

Resources:
* IPTables Essentials: Common Firewall Rules and COmmands https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
* List and Delete iptable rules: https://www.digitalocean.com/community/tutorials/how-to-list-and-delete-iptables-firewall-rules
