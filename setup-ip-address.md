### Setup ip address 
In the default settings, Raspberry Pi also receives its IP address via the DHCP server. The private IP addresses of individual devices can change though, depending on the configuration of the DHCP server.
To be able to reach Raspberry Pi on the same address in your own LAN, you have to provide it with a static, private IP address. 

Raspbian Jessie, or Jessie Lite – the current Raspbian operating systems at the moment – have a DHCP client daemon (DHCPCD) that can communicate with the DHCP servers from routers. The configuration file of a DHCP client daemon allows you to change the private IP address of a computer and set it up in the long term

Check if dhcpcd service is active or not. If not, start the service.
```
# service dhcpcd start
# systemctl enable dhcpcd
```
Open ```/etc/dhcpcd.conf``` and modify the following settings options to suit IP requirements.
```
interface eth0
static ip_address=192.168.0.4/24
static routers=192.168.0.1
static domain_name_servers=192.168.0.1
```

Close the above configuration file and reboot. New IP settings will be applied.

To check current "ip" configuration, use
```
# ifconfig -a
```
