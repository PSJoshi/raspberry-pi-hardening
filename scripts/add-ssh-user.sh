#!/bin/bash

USER_NAME=$1

# harden ssh configuration
sed -i "s/.*LogLevel.*/LogLevel VERBOSE/g" /etc/ssh/sshd_config
sed -i "s/.*MaxAuthTries.*/MaxAuthTries 4/g" /etc/ssh/sshd_config
sed -i "s/.*IgnoreRhosts.*/IgnoreRhosts yes/g" /etc/ssh/sshd_config
sed -i "s/.*HostbasedAuthentication.*/HostbasedAuthentication no/g" /etc/ssh/sshd_config
sed -i "s/.*PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config
sed -i "s/.*X11Forwarding.*/X11Forwarding no/g" /etc/ssh/sshd_config

sed -i "s/.*PermitEmptyPasswords.*/PermitEmptyPasswords no/g" /etc/ssh/sshd_config
sed -i "s/.*PermitUserEnvironment.*/PermitUserEnvironment no/g" /etc/ssh/sshd_config
sed -i "s/.*ClientAliveInterval.*/ClientAliveInterval 300/g" /etc/ssh/sshd_config
sed -i "s/.*ClientAliveCountMax.*/ClientAliveCountMax 1/g" /etc/ssh/sshd_config
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/sshd_config
sed -i "s/.*RSAAuthentication.*/RSAAuthentication yes/g" /etc/ssh/sshd_config
sed -i "s/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication no/g" /etc/ssh/sshd_config
sed -i "s/.*AuthorizedKeysFile.*/AuthorizedKeysFile\t\.ssh\/authorized_keys/g" /etc/ssh/sshd_config
sed -i "s/.*PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config
chown root:root /etc/ssh/sshd_config
chmod 600 /etc/ssh/sshd_config
systemctl restart sshd

echo "${USER_NAME}      ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

useradd -p "" $USER_NAME
passwd -fu $USER_NAME
sudo -u $USER_NAME mkdir /home/$USER_NAME/.ssh
sudo -u $USER_NAME chmod 700 /home/$USER_NAME/.ssh
sudo -u $USER_NAME ssh-keygen -t rsa -b 2048 -N "" -f /home/$USER_NAME/.ssh/id_rsa
cat /home/$USER_NAME/.ssh/id_rsa.pub > /home/$USER_NAME/.ssh/authorized_keys
chmod 600 /home/$USER_NAME/.ssh/authorized_keys
chown $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh/authorized_keys

