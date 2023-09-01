#!/bin/bash

# usage: service_monitor.sh httpd mariadb
# useful example:https://bash.cyberciti.biz/monitoring/monitor-unix-linux-network-services/

timeHour=`date +%H` # show hour portion in date
quietHour="02" # Don't run script during quiet hours

if ( echo ${timeHour} | grep ${quietHour}); then
    echo "During quiet time, script cannot run!.  Quiting."
    exit
fi

function service_check {
  service_name="${1}"
  # echo $service_name
  response=$(systemctl status ${service_name})
  # echo $response
  if [ "$response | grep -E -i 'inactive|not be found'" ] ; then
      echo "Error"
  else
     echo "Running!"
  fi
}

for i in $@
  do
    echo "Checking ${i}"
    service_check ${i}
  done
 
# curl -X POST https://reqbin.com/echo/post/json 
#   -H "Content-Type: application/json"
#   -d '{"datetime":"1693569329","server-nickname": "test","domain":"test.in","ip":"192.168.3.10", "status": "up"}' 
