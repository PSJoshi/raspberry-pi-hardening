### Setting up run level in  Linux

A runlevel is one of the modes that a Unix-based operating system will run in.
In Linux Kernel, there are 7 runlevels exists, starting from 0 to 6. The system can be booted into only one runlevel at a time.
By default, a system boots either to runlevel 3 or to runlevel 5. Runlevel 3 is CLI, and 5 is GUI. 
Here is the list of runlevels in Linux distributions,which were distributed with SysV init as default service manager.
* 0 - Halt
* 1 - Single-user text mode
* 2 - Not used (user-definable)
* 3 - Full multi-user text mode
* 4 - Not used (user-definable)
* 5 - Full multi-user graphical mode (with an X-based login screen)
* 6 - Reboot

#### Check runlevel
```
$ runlevel
N 5
```
In recent versions of Linux systems (starting from RHEL 7, Ubuntu 16.04 LTS), the concept of runlevels has been replaced with systemd targets.
Here is the list of Systemd targets in Linux distributions,which were distributed with Systemd as default service manager.
* runlevel0.target, poweroff.target - Halt
* runlevel1.target, rescue.target - Single-user text mode
* runlevel2.target, multi-user.target - Not used (user-definable)
* runlevel3.target, multi-user.target - Full multi-user text mode
* runlevel4.target, multi-user.target - Not used (user-definable)
* runlevel5.target,graphical.target - Full multi-user graphical mode (with an X-based login screen)
* runlevel6.target,reboot.target - Reboot

In Linux systems that are using Systemd as default service manager, you can find the current target using command:

```
$  systemctl get-default
```

To view all currently loaded targets, run:

```
$ systemctl list-units --type target
```

If you'd like to change the RunLevel to something else, for example runlevel3.target, set it as shown below:
```
$ sudo systemctl set-default runlevel3.target
```
To change to a different target unit in the current session only, run the following command:
```
$ sudo systemctl isolate runlevel3.target
```

#### Ref: 
* https://ostechnix.com/check-runlevel-linux/

