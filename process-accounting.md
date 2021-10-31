### Tracking processes 
#### What is process accounting
Process accounting allows you to record and summarize commands executed on Linux and enables you to keep detailed accounting information for the system resources used, their allocation among the users, and it helps you in system monitoring.

Modern Linux kernel allows you to track process accounting records for the commands being run, the user who executed the command(s), CPU utilization time, and many other attributes.A Linux kernel version greater than or equal to version- 1.3.73 is required.
#### How it's different from ```ps``` command
process accounting is different than the execution of the ```ps``` command. The ```ps``` command is used to print out the information related to the currently running process, including their PIDs. In contrast, process accounting displays the details of the completed commands, not the currently running ones. It has a single system file that stores more information than what is present inside the command history files. e.g. bash_history

#### Installation
Installation is simple - Just install acct package and enable it.
```
# sudo apt-get install acct
```
Now, enable the process accounting by issuing the command:
```
$ sudo /usr/sbin/accton on
```
It will save all of the data in the file -  “var/log/account/pacct”

It keeps track of user actions and permits you to see how long users have been connected to the system. This also provides a list of the commands and resources currently being used in the system. Since the “acct” runs in the background; therefore, the system’s performance is unaffected.

### Some useful commands
* user accounting summary (sa command)
 This command summarizes accounting information from previously executed commands, software I/O operation times, and CPU times, as recorded in the accounting record file ```/var/account/pacct```.
 Some commonly used commands are given below:
  * highest percentage of users
    ``` $ sa -c ```
  * total number of user processes and their CPU time
    ``` $ sa -m ```
  * individual user information
    ``` $ sa -u ```

* user connection statistics (ac command)
```ac``` prints out statistics about users' connection times in hours based on the logins and logouts in the current /var/log/wtmp file. ac is also capable of printing out time totals for each day (−d option), and for each user (−p option).
 Some commonly used commands are given below:
   * hour based connection times
      ``` $ ac ```
   * Daily log in hour-based time
      ``` $ ac -d ```   
   * connection times of system users
      ``` $ ac -p ```
   * log-in time statistics of particular user
        ``` $ ac <user> ```
        ``` 
          for display of day wise statistics
          $ ac -d <user>
        ```
* tracking historical commands (lastcomm command)
   "lastcomm" prints out the information about all previously executed commands, recorded in file - /var/account/pacct
   ``` $ lastcomm root ```

* Disabling process accounting
  ```
     $ sudo /usr/sbin/accton off
  ```  
