#!/bin/bash
# show memory usage by process

ps aux | head -1; ps aux | sort -rnk 4 | head -10

# another way
ps -o pid,user,%mem,command ax | sort -b -k3 -r

#* interesting github project
#  * Monitor Linux CPU and memory usage over time and output a CSV - https://github.com/f18m/CPU-MEM-monitor
