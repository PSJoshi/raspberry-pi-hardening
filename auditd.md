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
If you wish to send the auditd logs over syslog, you need to do the following changes:

* Edit /etc/audit/auditd.conf , and leave or change log_format to ‘RAW’
* Edit /etc/audit/auditd.conf and change write_logs to ‘no’
* Edit /etc/audispd/plugins/syslog.conf and set ‘active = yes’
