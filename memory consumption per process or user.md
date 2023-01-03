### Memory Consumption Per-Process and Per-User Basis in Linux
Smem is a command-line memory reporting tool thats gives a user diverse reports on memory usage on a Linux system. It reports PSS (Proportional Set Size), a more meaningful representation of memory usage by applications and libraries in a virtual memory setup.

Traditional tools focus mainly on reading RSS (Resident Set Size) which is a standard measure to monitor memory usage in a physical memory scheme, but tends to overestimate memory usage by applications. PSS on the other hand, gives a reasonable measure by determining the “fair-share” of memory used by applications and libraries in a virtual memory scheme.

#### Installation
* CentOS or RHEL OS
Enable EPEL repository first.
```
# yum install smem python-matplotlib python-tk
```
* Ubuntu
```
# apt-get install smem
```
#### Smem commands
* report of memory usage across the whole system by all system users
```
$ sudo smem
```
* view system wide memory consumption
```
$ sudo smem -w
```
* memory usage on a per-user basis
```
$ sudo smem -u
```
* Filter output by username - use -u or --userfilter="regex" option 
```
$ sudo smem -u
```
* Filter output by process name - use -P or --processfilter="regex" option 
```
$ sudo smem --processfilter="firefox"
```
* Custom columns in the report - use -c or --columns option
```
$ sudo smem -c "name user pss rss"
```
* Memory usage in percentages - use -p option
```
$ sudo smem -p
```

