#!/bin/bash

metrics_report="/tmp/sar-metrics-report.md"

echo -e "\n Per-Day averages this week:\n" >> $metrics_report 

echo "Day of Week | %CPU | Load | %Mem " >> $metrics_report
echo "----------- | ---- | ---- | ---- " >> $metrics_report
echo ""

week_days=7
for days_ago in $(seq 1 $week_days); do 
#  echo $i
# done
    # Only report system metrics if they exist in sysstat. 
    if [ -e /var/log/sysstat/sa$(date -d "-$days_ago day" +%d) ]; then 
        # sar sometimes prints two averages if the system restarted.
        #   so, just accept the last average it took from that day. 
        cpu_avg=$(sar -$days_ago     | grep Average | tail -n1 | awk '{print $3}') 
        load_avg=$(sar -$days_ago -q | grep Average | tail -n1 | awk '{print $5}')
        mem_avg=$(sar -$days_ago  -r | grep Average | tail -n1 | awk '{print $5}')
        echo "$(date -d "-$days_ago day" +%a) | $cpu_avg | $load_avg | $mem_avg" >> $metrics_report
    fi 
done

echo "High CPU Periods:" >> $metrics_report

for days_ago in $(seq 1 $week_days); do 
    if [ -e /var/log/sysstat/sa$(date -d "-$days_ago day" +%d) ]; then 
    unset spike_time 
    spike_time=$(sar -$days_ago | awk '$8 ~ /^[1-9].[0-9]{2}/ {print $1}')
    if [ -n "$spike_time" ]; then 
        echo "* $(date -d "-$days_ago day" +%y-%m-%d) $spike_time " >> $metrics_report
    fi
    fi 
done 
exit 1

