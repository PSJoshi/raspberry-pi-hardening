#!/bin/bash

# this can be used to check the health of VPN tunnel.

# you can run this script as a part of cronjob - say every 5 minutes. VPN will not be down for more than 5 minutes. If the interface is down, restart it again and establish tunnel.
# Once tun0 is up, it does ping test on 2 public IPs and check its response.

# add hostnames seperated by spaces
INET_SERVERS="8.8.8.8 4.2.2.4"

total_count=0
PING_COUNT=4

DATE=`date +%Y-%m-%d:%H:%M:%S`

if ! /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
    echo $DATE   tun0 down
    echo "restarting VPN"
    #sudo vpn_start.sh 
else
    for serv in $INET_SERVERS;
    do
        count=`ping -c $PING_COUNT $serv | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }'`
        total_count=$(($total_count + $count))
    done

    if [ $total_count -eq 0 ]
    then
       echo "Failure in getting response from $serv"
       echo $DATE  $totalcount "fail"
       echo "restarting VPN"
       #sudo vpn_start.sh
    #else
       #echo $DATE      $totalcount "pass"
    fi
fi
