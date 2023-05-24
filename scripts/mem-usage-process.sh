#!/bin/bash
# use ps to extract memory usage
mem_info=$(ps -o pid,user,%mem,command ax | grep -v PID | awk '/[0-9]*/{print $1 ":" $2 ":" $3 ":" $4}')

# use pmap to extract actual memory usage 
# many processes use shared libraries and hence, individual memory usage of the process may not be accurate. pmap gives the the "writeable/private" total memory usage of a process factoring out shared libraries.
    for i in $mem_info

    do
        process_pid=$(echo $i | cut -d: -f1)
        user=$(echo $i | cut -d: -f2)
        cmd=$(echo $i | cut -d: -f4)
        mem_usage=$(pmap $process_pid | tail -n 1 | awk '/[0-9]/{print $2}')
        
        echo "$process_pid" "$user" "$mem_usage" "$cmd"

    done
    

# ps -eo pid,tid,class,rtprio,stat,vsz,rss,comm |sort -k 7 -r|more
# ps -eo pid,stat,vsz,rss,%mem |sort -k 5 -r |mor
