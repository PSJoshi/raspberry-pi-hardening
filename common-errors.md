### How to fix "sshd error: could not load host key"
On client side, you are receiving messages like
```
Connection closed by XXXX
```
```
Connection reset by XXXX
```
On the server side, system log ```/var/log/auth.log``` has messages like
```
Oct 20 07:50:45 openstack sshd[1214]: error: Could not load host key: /etc/ssh/ssh_host_rsa_key
Oct 20 07:50:45 openstack sshd[1214]: error: Could not load host key: /etc/ssh/ssh_host_dsa_key
Oct 20 07:50:45 openstack sshd[1214]: error: Could not load host key: /etc/ssh/ssh_host_ecdsa_key
Oct 20 07:50:45 openstack sshd[1214]: fatal: No supported key exchange algorithms [preauth]
```
The root cause of this problem is that sshd daemon somehow is not able to load SSH host keys properly.
On Ubuntu or their derivatives, you can use ```dpkg-reconfigure``` tool to regenerate SSH host keys as follows.
```
$ sudo rm -r /etc/ssh/ssh*key
$ sudo dpkg-reconfigure openssh-server
```
You can also regenerate ssh-keys using ssh-keygen command:
```
$ sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
$ sudo ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
$ sudo ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
```
