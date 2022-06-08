#!/bin/bash

# This script is used to monitor ipsec based vpn tunnel

# get interface through "-i" or "--interface" argument 
if [$# -eq 0 ] ; then
  echo " No argument specified"
elif [ $# -eq 1 ] ; then
  #echo ""
  INTERFACE=$1
else
  echo "Invalid arguments"
  exit
fi

# show an error if the interface isn't specified
if [ -z "$INTERFACE" ] 
  then
    echo "You must provide an interface argument with -i or --interface"
    exit
fi
 
# restart ipsec, then bring up the IPSec tunnel
/sbin/service ipsec restart
/usr/sbin/ipsec whack --shutdown
/usr/sbin/ipsec setup --restart
/usr/sbin/ipsec auto --add $INTERFACE
sleep 5
/usr/sbin/ipsec auto --up $INTERFACE

# Ref - https://www.justinsilver.com/technology/linux/monitor-ipsec-vpn-tunnel/
