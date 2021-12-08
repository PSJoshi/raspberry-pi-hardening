#!/bin/bash

# Restrictive IPTables based firewall rules for hardened machine
# To make rules persistent
# Add in /etc/network/interfaces
#        iface eth0 inet dhcp
#        pre-up iptables-restore < /etc/network/iptables
# 

##
# https://gist.github.com/cedricwalter/1690823
# https://gist.github.com/f1r-CTLF/3174f9f8ddc1edb37e03
# https://gist.github.com/jirutka/3742890

IPTables_cmd="/sbin/iptables"

### Interfaces ###
PUB_IF="eth0"   # public interface
LO_IF="lo"      # loopback

ALLOW_INCOMING_ICMP="true"

########## SSH #################################################
SSH_PORT=22
ALLOW_SSH="true"

# Every NEW connection to port ${SSH_PORT} is tracked and added to the recent "list"
# If your IP is on the recent list, and if you have ${SSH_LOGIN_ATTEMPT} or more entries on the list in the
# last ${SSH_LOGIN_ATTEMPT_TIMEFRAME} seconds, the request is dropped.
SSH_LOGIN_ATTEMPT_PROTECTION="true"
SSH_LOGIN_ATTEMPT=4
SSH_LOGIN_ATTEMPT_TIMEFRAME_SECONDS=90

# allow selected ips only for ssh
SSH_ALLOW_ONLY_IP="false"
SSH_ALLOW_ONLY_IP_LIST="14.xx.yy.zz/24"
#####################################################################


function clear_rules() {
    echo "Clearing all firewall rules";
    #Default policy is DROP so first change the INPUT FORWARD and OUTPUT policy before the -F or you will be locked.
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT 
    iptables -F
    iptables -X
    iptables -t nat -F
    iptables -t nat -X
    iptables -t mangle -F
    iptables -t mangle -X
}

function loopback_rules() {
    # Don't attempt to firewall internal traffic on the loopback device.
    $IPTables_cmd -A INPUT -i lo -j ACCEPT
    $IPTables_cmd -A OUTPUT -o lo -j ACCEPT
    
    # Block remote packets claiming to be from a loopback address.
    $IPTables_cmd -A INPUT -s 127.0.0.0/8 ! -i lo -j DROP
}

function hardening_rules() {
    echo "Hardening: Make sure that incoming connections are SYN packets; other wise DROP"
    $IPTables_cmd -A INPUT -i ${PUB_IF} -p tcp ! --syn -m state --state NEW -j DROP

    echo "Hardening: Drop Fragments"
    $IPTables_cmd -A INPUT -i ${PUB_IF} -f -j DROP

    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags ALL ALL -j DROP
	 
    echo "Hardening: Drop NULL packets"
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags ALL NONE -m limit --limit 5/m --limit-burst 7 -j LOG --log-prefix " NULL Packets "
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags ALL NONE -j DROP

    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

    echo "Hardening: Drop XMAS"
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags SYN,FIN SYN,FIN -m limit --limit 5/m --limit-burst 7 -j LOG --log-prefix " XMAS Packets "
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
 
    echo "Hardening: Drop FIN packet scans"
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags FIN,ACK FIN -m limit --limit 5/m --limit-burst 7 -j LOG --log-prefix " Fin Packets Scan "
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags FIN,ACK FIN -j DROP

    $IPTables_cmd  -A INPUT -i ${PUB_IF} -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
	 
    echo "Hardening: Drop broadcast / multicast and invalid"
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -m pkttype --pkt-type broadcast -j LOG --log-prefix " Broadcast "
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -m pkttype --pkt-type broadcast -j DROP
	 
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -m pkttype --pkt-type multicast -j LOG --log-prefix " Multicast "
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -m pkttype --pkt-type multicast -j DROP
	 
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -m state --state INVALID -j LOG --log-prefix " Invalid "
    $IPTables_cmd  -A INPUT -i ${PUB_IF} -m state --state INVALID -j DROP
}	

function ssh_rules() {
    if [ "${ALLOW_SSH}" == "true" ]; then
        echo "Allowing SSH";

        if [ "${SSH_ALLOW_ONLY_IP}" == "true" ]; then
           # Allow ssh only from selected ips
           for ip in ${SSH_ALLOW_ONLY_IP_LIST}
               do
                   $IPTables_cmd -A INPUT -i ${PUB_IF} -s ${ip} -p tcp -d ${SERVER_IP} --destination-port 22 -j ACCEPT
                   $IPTables_cmd -A OUTPUT -o ${PUB_IF} -d ${ip} -p tcp -s ${SERVER_IP} --sport 22 -j ACCEPT
	       done
        else
          # allow for all
           $IPTables_cmd -A INPUT -i ${PUB_IF}  -p tcp -d ${SERVER_IP} --destination-port ${SSH_PORT} -j ACCEPT
           $IPTables_cmd -A OUTPUT -o ${PUB_IF} -p tcp -s ${SERVER_IP} --sport ${SSH_PORT} -j ACCEPT
        fi 
	 
        if [ "${SSH_LOGIN_ATTEMPT_PROTECTION}" == "true" ]; then
           $IPTables_cmd -I INPUT -p tcp --dport ${SSH_PORT} -i eth0 -m state --state NEW -m recent --set
           $IPTables_cmd -I INPUT -p tcp --dport ${SSH_PORT} -i eth0 -m state --state NEW -m recent --update --seconds ${SSH_LOGIN_ATTEMPT_TIMEFRAME_SECONDS} --hitcount ${SSH_LOGIN_ATTEMPT} -j DROP
        fi 
        
    fi  
}

function icmp_rules() {
    if [ "${ALLOW_INCOMING_ICMP}" == "true" ]; then
        echo "Allow incoming ICMP";
        $IPTables_cmd -A INPUT -i ${PUB_IF} -p icmp --icmp-type 8 -s 0/0 -m state --state NEW,ESTABLISHED,RELATED -m limit --limit 30/sec  -j ACCEPT
        $IPTables_cmd -A OUTPUT -o ${PUB_IF} -p icmp --icmp-type 0 -d 0/0 -m state --state ESTABLISHED,RELATED -j ACCEPT
    fi
}

function http_rules() {
    if [ "${ALLOW_HTTP}" == "true" ]; then
         echo "Allow HTTP";
         $IPTables_cmd -A INPUT -i ${PUB_IF} -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
	 #Allow outgoing (ESTABLISHED only) HTTP connection response (for the corrresponding incoming connection request).
	 $IPTables_cmd -A OUTPUT -o ${PUB_IF} -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
    fi
}

function https_rules() {
    if [ "${ALLOW_HTTPS}" == "true" ]; then
         echo "Allow HTTPS";
         $IPTables_cmd -A INPUT -i ${PUB_IF} -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
	 #Allow outgoing (ESTABLISHED only) HTTP connection response (for the corrresponding incoming connection request).
	 $IPTables_cmd -A OUTPUT -o ${PUB_IF} -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT
    fi
}

function ntp_rules() {
    if [ "${ALLOW_NTP}" == "true" ]; then
        echo "Allow NTP";
        $IPTables_cmd -A OUTPUT -o ${PUB_IF} -p udp --dport 123 -m state --state NEW,ESTABLISHED -j ACCEPT
        $IPTables_cmd -A INPUT -i ${PUB_IF} -p udp --sport 123 -m state --state ESTABLISHED -j ACCEPT
    fi
}

function smtp_rules() {
	if [ "${ALLOW_SMTP}" == "true" ]; then
	 echo "Allow local SMTP";
	 $IPTables_cmd -A OUTPUT -o ${PUB_IF} -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
	 $IPTables_cmd -A INPUT -i ${PUB_IF} -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
	fi
}

function set_policy() {
    echo "Drop And Close Everything";
    $IPTables_cmd -P INPUT DROP
    $IPTables_cmd -P OUTPUT DROP
    $IPTables_cmd -P FORWARD DROP
}

function drop_log_all() {
    $IPTables_cmd -A INPUT -m limit --limit 5/m --limit-burst 7 -j LOG --log-prefix " DEFAULT DROP "
    $IPTables_cmd -A INPUT -j DROP
}

function create_rules() {
    echo "Setting $(hostname) firewall rules...";
    set_policy
    loopback_rules
    hardening_rules
    ssh_rules
    http_rules
    #https_rules
    icmp_rules	
    ntp_rules 
    smtp_rules
    drop_log_all
}

echo " Firewall script by Joshi P S, SAS,CD"
echo " All the credits to open source community - GNU/GPL 3.0 Script"
echo " Choose one of the following options:" 
echo
echo "[N]ew firewall rules"
echo "[C]lear all firewall rules"
echo "[T]est firewall rules"
echo "[S]ave firewall rules to /etc/network/iptables"
echo "[E]xit"
echo

read choice

case "$choice" in
  "N" | "n" )
	clear_rules
	create_rules
  ;;
  "C" | "c" )
    clear_rules
  ;;
  "T" | "t" )
	clear_rules
	create_rules
    iptables-apply
  ;;
  "S" | "s" )
	clear_rules
	create_iptables_rules
	iptables-save > /etc/network/iptables
  ;;
  * )
   exit 0
  ;;

esac
