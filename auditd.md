### Viewing audit rules
 The current set of audit rules using the command auditctl -l.
```
$ sudo auditctl -l
```

The current status of the audit system can be viewed using:
```
sudo auditctl -s
```
#### Read rules file
```
sudo auditctl -R /etc/auditd/audit.rules
```
#### Delete all rules
```
auditctl -D
```
#### List existing rules
```
# auditctl -l
```
### Reset lost record counter
```
# auditctl --reset-lost
```
If you wish to send the auditd logs over syslog, you need to do the following changes:

* Edit /etc/audit/auditd.conf , and leave or change log_format to ‘RAW’
* Edit /etc/audit/auditd.conf and change write_logs to ‘no’
* Edit /etc/audispd/plugins/syslog.conf and set ‘active = yes’

### Interesting links
* https://dev.to/ajaykdl/how-to-setup-auditd-on-ubuntu-jfk
* https://goteleport.com/blog/linux-audit/
* https://www.baeldung.com/linux/auditd-monitor-file-access
