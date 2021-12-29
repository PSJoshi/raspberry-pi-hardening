### Unhide - Find hidden processes
Although linux is considered to be secure OS, there are possibilities that the system may be compromised by malware, rootkits attacks. Rootkits are especially dangerous as these gain access to the system and do malicious actions without user's knowledge. "Unhide" program provides a mean to quickly scan the system for such malicious softwares/processes.

Unhide is in the repositories for most of the major Linux distributions and you can simply install it using
* Ubuntu
```
# apt install unhide
```
* CentOS
```
# yum install unhide
```

#### Quicker test:
This technique scans proc lists as well as the proc file system.

```
# unhide quick
```
or

An excellent technique for sniffing out rootkits involves verification of all ps threads. Reverse scanning verifies that each of the processor threads that ps images exhibit valid system calls and can be looked up in the procfs listing.

```
unhide quick reverse
```

#### Standard test
```
unhide sys proc
```
#### Deeper test
```
# unhide -m -d sys procall brute reverse
```

### Brute force process IDs
Bruteforcing each process ID to make sure that none of them have been hidden from the user. 
```
# unhide brute -d
```
### Comparing /proc and /bin/ps 
Compare the /bin/ps and /proc process lists to ensure that these two separate lists in the Unix file tree match. If there is something awry, then the program will report the unusual PID. 
```
# unhide proc -v
```
### Combining the Proc and Procfs Techniques
If you wish, you can compare the /bin/ps and /proc Unix file tree lists while also also comparing all of the information from the /bin/ps list with the virtual procfs entries. 
```
# unhide procall -v 
```

### Logging to file
-f log-to-file command to make it easier to look back through everything it found.
```
# unhide -m -d sys procall brute reverse -f unhide.log
```
