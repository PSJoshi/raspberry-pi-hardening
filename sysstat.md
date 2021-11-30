### Tracking system activities using sysstat package
SYSSTAT is a software application comprised of several tools that offers advanced system performance monitoring. It provides the ability to create a measurable baseline of server performance, as well as the capability to formulate, accurately assess and conclude what led up to an issue or unexpected occurrence. In short, it lets you peel back layers of the system to see how it‚Äôs doing… in a way it is the blinking light telling you what is going on, except it blinks to a file. SYSSTAT has broad coverage of performance statistics and will watch the following server elements:
* Input/Output and transfer rate statistics (global, per device, per partition, per network filesystem and per Linux task / PID)
* CPU statistics (global, per CPU and per Linux task / PID), including support for virtualization architectures
* Memory and swap space utilization statistics
* Virtual memory, paging and fault statistics
* Per-task (per-PID) memory and page fault statistics
* Global CPU and page fault statistics for tasks and all their children
* Process creation activity
And so on.

So, it's always useful to have these stats collected at periodic intervals to gain insights into the system.


* Installation
```
# Ubuntu and Debian systems
$ sudo apt-get -y install sysstat 
```
* Configure sysstat

By default. Sysstat monitoring is disabled. So, edit the configuration file ```/etc/default/sysstat``` and enable monitoring:
```
$ sudo nano /etc/default/sysstat
```
Set "Enabled" option to True for enabling monitoring. 
```
ENABLED="true"
```
Further, the debian package, by default, only logs "Disk" statistics when you run system statistics daemon. To collect all the statistics, you need to modift the file ```/etc/sysstat/sysstat```
Default:
```
$ sudo cat /etc/sysstat/sysstat|grep -v ^#|grep -v ^$
HISTORY=7
COMPRESSAFTER=10
SADC_OPTIONS="-S DISK"
SA_DIR=/var/log/sysstat
ZIP="xz"
UMASK=0022
```
Change the above configuration to collect all system metrics
```
$ sudo cat /etc/sysstat/sysstat|grep -v ^#|grep -v ^$
HISTORY=7
COMPRESSAFTER=10
SADC_OPTIONS="-S XALL"
SA_DIR=/var/log/sysstat
ZIP="xz"
UMASK=0022
```
Now, enable sysstat service and start it by executing:
```
$ sudo systemctl enable sysstat
$ sudo systemctl start sysstat
```

* Create sysstat cron file - /etc/cron.d/sysstat and set to run under 10 minute interval
```
# Run system activity accounting tool every 10 minutes
*/10 * * * * root /usr/lib64/sa/sa1 60 10
```
The above will run the cron job every 10 minutes with sa1 running every minute for 10 counts. You can change to “sa1 5 120” to capture every 5 seconds or “sa1 2 300” for every two seconds.

* Restart the sysstat service:
```
#sudo systemctl restart sysstat.service
```
### System activity data collector
The sadc [system activity data collector](https://dashdash.io/8/sadc#options) operation performs data collection. Collected data is written in text format and contained in the sar## files in the /var/log/sysstat or /var/log/sa/ directory.

The sadc operation is classified into two components:
    * sa1 - Collect and store binary data in the system activity daily data file.
    * sa2 - Write a daily report to the /var/log/sa directory.

The /var/log/sa/ directory contains the following two sets of files:
    * sa# - system activity binary data files.
    * sar## - system activity report files.
Note: ## represents the day of the month
### Data collection interval
To view the scripts that the SAR utility runs in crontab to generate data:
```
$ cat /etc/cron.d/sysstat
```
By default, SAR generates data every 10 minutes as the cron runs every 10 minutes. You can edit this value to allow SAR to generate data for shorter or longer intervals.e.g. the following crontab file generate SAR data every 10 minutes:

*/10 * * * * root /usr/lib64/sa/sa1 1 1

It's a best practice to change cron to run on a 5 or 1 minute interval. By changing to a shorter interval, it's possible to catch cases where spikes are observed or when every minute monitoring is required. But, the amount of SAR data will be large. So, make a calculated decision of setting SAR interval.
### Peformance report examples using SAR
* CPU usage
The following command generates a usage data report 5 times every 2 seconds. The option "-P" indicates an individual CPU or core and you can generate statistics for each core by specifying 0, 1, 2, 3, and so on. Or, you can use the command -P ALL to display statics for all CPUs.
```
$ sar 2 5 -P 0
```
* Memory statistics
The following command generates memory statistics 5 times every 2 seconds:
```
$ sar -r 2 5
```
* Block device statistics report
The following command generates block device statistics 5 times every 2 seconds.
```
$ sar -d -p 2 5
```
* Network statistics report 
You can generate statistics for specific entities, such as TCP, UDP, NFS, etc. or ALL network protocols - e.g.
```
$ sar -n TCP 2 5
$ sar -n UDP 2 5
```
### Reading existing system reports from log files
* Read from most recent log file - /var/log/sysstat/sa
```
$ sar -f /var/log/sysstat/sa
```
* system reports for specific day
The system log report file is saved day-wise. So, if you want to extract details for a specific day, use the -f option for the relevant sa file on that date. e.g. the following command displays all the data from the log file containing data from the 30th day of the current month
```
$ sar -f /var/log/sysstat/sa30
```
* Read specific statistics from log file
  * memory stats:
    ````
    $ sar -f /var/log/sysstat/sa30 -r
    ```
  * I/O stats:
    ````
    $ sar -f /var/log/sysstat/sa30 -b
    ```
  * network stats:
    ````
    $ sar -f /var/log/sysstat/sa30 -n ALL
    ```
  * CPU stats:
    ````
    $ sar -f /var/log/sysstat/sa30 -P 0
    ```
###  View statistics for a specific time period

Use the -s and -e options to designate start and end times. The times entered must be in the 24 hour format. The default end time is 18:00. The following example command displays block device statistics from the log file generated on the 30th day of the month between 4:00 and 5:00.
```
$ sar -f /var/log/sysstat/sa30 -dp -s 04:00:00 -e 05:00:00
```
If you want to routinely get yesterday's file and can never remember the date and have GNU date you could try
```
$ sar -f /var/log/sysstat/sa$(date +%d -d yesterday) -A
```
### Interesting links
* Amazon EC2 performance monitoring - https://aws.amazon.com/premiumsupport/knowledge-center/ec2-linux-monitor-performance-with-sar/
* Sysstat email report - https://github.com/desbma/sysstat_mail_report
* System statistics examples - https://www.linuxtechi.com/generate-cpu-memory-io-report-sar-command/
* https://tecadmin.net/how-to-install-sysstat-on-ubuntu-20-04/
* https://sleeplessbeastie.eu/2019/07/03/how-to-collect-system-activity-information/    
