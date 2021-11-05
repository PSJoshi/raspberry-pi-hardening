### Tracking system activities using systat
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
* Create sysstat cron file - /etc/cron.d/sysstat and set to a 1 minute interval
```
# Run system activity accounting tool every 10 minutes
*/10 * * * * root /usr/lib64/sa/sa1 60 10
```
The above will run the cron job every 10 minutes with sa1 running every minute for 10 counts. You can change to “sa1 5 120” to capture every 5 seconds or “sa1 2 300” for every two seconds.

* Restart the sysstat service:
```
#sudo systemctl restart sysstat.service
```
