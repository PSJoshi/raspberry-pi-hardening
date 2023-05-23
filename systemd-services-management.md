Systemctl is a systemd utility that is responsible for controlling systemd system and service manager. Systemd is a collection of system management daemons, utilities and libraries which serves as a replacement of System V init daemon. Systemd functions as central management and configuration platform for UNIX like system.
Some useful commands related to systemd are listed below:
* Path for systemd binaries
```
# whereis systemd 
```
```
# whereis systemctl
```
* Check if systemd is running
```
# ps -eaf | grep [s]ystemd
```
* Analyze systemd boot process
``` 
# systemd-analyze
```
* Analyze time taken by each process at boot
```
# systemd-analyze blame
```
* Analyze critical chain at boot.
```
# systemd-analyze critical-chain
```
* List all the available units
```
# systemctl list-unit-files
```
* List all running units
```
# systemctl list-units
```
* List all failed units
```
# systemctl --failed
```
* Check if a Unit (cron.service) is enabled
```
# systemctl is-enabled crond.service
```
* Check whether a Unit or Service is running or not
```
# systemctl status firewalld.service
```
* List all services (including enabled and disabled)
```
# systemctl list-unit-files --type=service
```
* Enable/disable service
```
# systemctl is-active httpd.service
# systemctl enable httpd.service
# systemctl disable httpd.service
```
* mask (making it impossible to start) or unmask a service (httpd.service)
```
# systemctl mask httpd.service
```
* Get the current CPU Shares of a Service (say httpd)
```
# systemctl show -p CPUShares httpd.service
```
* Check all the configuration details of a service
```
# systemctl show httpd
```
* Analyze critical chain for a services(httpd)
```
# systemd-analyze critical-chain httpd.service
```
* Get a list of dependencies for a services (httpd)
```
# systemctl list-dependencies httpd.service
```




