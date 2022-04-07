### Change default port of SSH
By default, SSH listens on port 22. Changing the default SSH port adds an extra layer of security to your server by reducing the risk of automated attacks.

In Linux, port numbers below 1024 are reserved for well-known services and can only be bound to by root. Although you can use a port within a 1-1024 range for SSH, it is recommended to choose a port above 1024 to avoid issues with port allocation in the future.

Let's change the port of SSH to 2022.

#### Adjust firewall rules
If you are using UFW firewall in Ubuntu, run the following command to open the new SSH port:
```
$ sudo ufw allow 2022/tcp
```
In CentOS, change the FirewallD rules.
```
$ sudo firewall-cmd --permanent --zone=public --add-port=2022/tcp
$ sudo firewall-cmd --reload
```

If you are using SELinux in CentOS, you need to adjust the SELinux rules:
```
$ sudo semanage port -a -t ssh_port_t -p tcp 2022
```
If you are using iptables, do this modification:
```
$ sudo iptables -A INPUT -p tcp --dport 2022 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
```
#### sshd configuration
Edit the file ```/etc/ssh/sshd_config``` and change the port line to 2022
```
Port 2022
```
Save the file and restart the SSH service to apply the changes.
```
sudo systemctl restart ssh
```

To verify that SSH daemon is listening on the new port 2022, type:
```
$ ss -an | grep 5522
```
