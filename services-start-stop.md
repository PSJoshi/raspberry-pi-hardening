### List services
```
# systemctl list-units --type=service
```
### Running services
```
# systemctl list-units --type=service --state=running
```
### Boot time services
```
# systemctl list-unit-files --state=enabled
```
### Disabled services
```
# systemctl list-unit-files --state=disabled
```
### Check service status
```
# systemctl status cups.service
```
### Disable service at boot e.g. unbound
```
$ sudo systemctl stop <service-name>
$ sudo systemctl status <service-name>
$ sudo systemctl disable <service-name>
$ sudo systemctl status unbound
```
### service automatically started at boot time
```
$ sudo update-rc.d ssh defaults
```
### service not started automatically
```
$ sudo update-rc.d -f ssh remove
```
