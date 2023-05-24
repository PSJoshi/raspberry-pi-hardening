#!/bin/bash
# How to run:
#
# sh harden-home.sh > /dev/null 2>&1
#
harden_home () {

# get user list
result=$(getent passwd | grep -v "nologin" | grep -v "/bin/false" | sort | uniq | cut -d: -f1 |sort | uniq)

# iterate through valid users
for user_name in $result
  do
    # check if home directory exists
      ls -l /home/$user_name
      dir_exists=$?
      #dir_exists=$(ls -l /home/$user_name)
      #echo $?

      if [ "$dir_exists" -eq 0 ]
      then
          #echo $user_name
          # CIS-6.2.8 
          # Ensure users' home directories permissions are 750 or more restrictive
          chmod -R 750 /home/$user_name
          # 5.4.1.4 Ensure inactive password lock is 30 days or less          
          chage --inactive 30 --maxdays 90 --mindays 7 --warndays 7 $user_name
      fi
  done

}

harden_password_settings () {
    # 5.4.1.4 Ensure inactive password lock is 30 days or less
    useradd -D -f 30
    sed -i '/^PASS_MAX_DAYS/c\# This line is hardened according to the CIS Linux Benchmark, Section 5.4.1.1\nPASS_MAX_DAYS 90' /etc/login.defs
    sed -i '/^PASS_MIN_DAYS/c\# This line is hardened according to the CIS Linux Benchmark, Section 5.4.1.2\nPASS_MIN_DAYS 7' /etc/login.defs
}

harden_ssh () {

    # SSH Server Configuration - hardening
    rm -f /etc/ssh/sshd_config
    cp /usr/share/ssh/sshd_config /etc/ssh/sshd_config
    # 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured
    chown root:root /etc/ssh/sshd_config
    chmod og-rwx /etc/ssh/sshd_config
    # 5.2.2 Ensure SSH Protocol is set to 2
    # 5.2.3 Ensure SSH LogLevel is set to INFO
    # 5.2.4 Ensure SSH MaxAuthTries is set to 4 or less
    # 5.2.5 Ensure SSH IgnoreRHosts is enabled
    # 5.2.6 Ensure SSH HostbasedAuthentication is disabled
    # 5.2.7 Ensure SSH root login is disabled
    # 5.2.8 Ensure SSH PermitEmptyPasswords is disabled
    # 5.2.9 Ensure SSH PermitUserEnvironment is disabled
    # 5.2.10 Ensure only approved ciphers are used
    # 5.2.11 Ensure Idle Timeout Interval is configured
    # 5.2.13 Ensure SSH LoginGraceTime is set to one minute or less
    # 5.2.14 Ensure SSH access is limited
    # 5.2.15 Ensure SSH warning banner is configured
    cat > /etc/ssh/sshd_config << EOF
        Banner /etc/issue.net
        Protocol 2
        UsePAM yes
        LogLevel INFO
        X11Forwarding no
        MaxAuthTries 4
        IgnoreRhosts yes
        HostbasedAuthentication no
        PermitRootLogin no
        PermitEmptyPasswords no
        PermitUserEnvironment no
        Ciphers aes256-ctr,aes192-ctr,aes128-ctr
        MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
        ClientAliveInterval 300
        ClientAliveCountMax 0
        LoginGraceTime 60
        # AllowUsers core
    EOF
}

bootloader_permissions () {

# 1.4.1 - Ensure permissions on bootloader config are configured (Scored)

file=/boot/grub2/grub.cfg
perm="600 0 0"

p=$(echo $perm | awk {'print $1'} | sed "s/[^0-9]//g" )
o=$(echo $perm | awk {'print $2'})
g=$(echo $perm | awk {'print $3'})

touch $file

if [[ $o -eq 0 && $g -eq 0 ]]; then
        chown root:root $file
fi

chmod $p $file

}

harden_security_limits() {

# 1.5.1 - Ensure core dumps are restricted (Scored)
echo "hard core 0" >> /etc/security/limits.d/CIS.conf

}

harden_sysctl () {
    # remove existing sysctl configuration parameters
    rm -f /etc/sysctl.d/cis.conf
    touch /etc/sysctl.d/cis.conf
 
    # Ensure appropriate permissions on /etc/sysctl.d/cis.conf
    chown root:root /etc/sysctl.d/cis.conf
    chmod 0600 /etc/sysctl.d/cis.conf
   
    cat > /etc/sysctl.d/cis.conf << EOF
         net.ipv4.ip_forward = 0
         net.ipv4.conf.all.send_redirects = 0
         net.ipv4.conf.default.send_redirects = 0
         net.ipv4.conf.all.accept_redirects = 0
         net.ipv4.conf.default.accept_redirects = 0
         net.ipv4.conf.all.secure_redirects = 0
         net.ipv4.conf.default.secure_redirects = 0
         net.ipv4.conf.all.log_martians = 1
         net.ipv4.conf.default.log_martians = 1
         net.ipv4.conf.all.accept_source_route=0
         net.ipv4.conf.default.accept_source_route=0
         net.ipv4.icmp_echo_ignore_broadcasts=1
         net.ipv4.icmp_ignore_bogus_error_responses=1
         net.ipv4.conf.all.rp_filter=1
         net.ipv4.conf.default.rp_filter=1
         net.ipv4.tcp_syncookies=1                                             
         net.ipv6.conf.all.accept_ra = 0
         net.ipv6.conf.default.accept_ra = 0
         net.ipv6.conf.all.accept_redirects = 0
         net.ipv6.conf.default.accept_redirects = 0
         net.ipv6.conf.all.disable_ipv6=1
         fs.suid_dumpable=0
         net.ipv4.route.flush=1
         kernel.randomize_va_space=2
    EOF

}

# 1.5.4 - Ensure prelink is disabled (Scored)
yum remove prelink -y 

harden_home
harden_password_settings
harden_ssh
harden_sysctl 
