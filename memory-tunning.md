### Tunning linux kernel
You should leave no more than 3% of spare memory to min_free_kbytes in order to avoid the kernel spending too much time unnecessarily reclaiming memory. This would equal anywhere between 1.1GB and 3% of total RAM on such systems.

Add the following settings to /etc/sysctl.conf
```
vm.min_free_kbytes = 1153434
vm.swappiness = 0
```

```/proc/meminfo``` file provides the ```MemAvailable``` field. To determine how much memory is available, run:
```
# cat /proc/meminfo | grep MemAvailable
```
#### Tracking memory usage
To find out processes wise memory consumption, you may use "pidstat" command which is part of the sysstat package. So, to find out memory usage for active process 
```
# pidstat -l -r|sort -k8nr
```
#### Memory Overcommit 
Usually, the Linux server will allow more memory to be reserved for a process than its actual requirement, this is based on the assumption that no process will use all the memory allowed for it which can be used for other processes. It is possible to configure the Linux system how it handles the memory overcommit 

```
# sysctl -a | grep vm.overcommit_memory
vm.overcommit_memory = 0
```
overcommit_memory options:
* 0 - Allow overcommit based on the estimate “if we have enough RAM” 
* 1 - Always allow overcommit 
* 2 - Deny overcommit if the system doesn’t have the memory.

Another sysctl parameter to consider is the overcommit_ratio, which defines what percentage of physical memory in addition to the swap space can be considered when allowing processes to overcommit. 
So, usually, the following settings are applied in sysctl.conf
```
# sysctl -w vm.overcommit_memory=2
# sysctl -w vm.overcommit_ratio=100
```

#### References
* https://discuss.aerospike.com/t/how-to-tune-the-linux-kernel-for-memory-performance/4195
* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/performance_tuning_guide/s-memory-tunables
* https://www.eurovps.com/faq/how-to-troubleshoot-high-memory-usage-in-linux/

