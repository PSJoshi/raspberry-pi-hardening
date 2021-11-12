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
