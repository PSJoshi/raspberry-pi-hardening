### Journalctl 
Journalctl is a utility for querying and displaying logs from journald, systemd’s logging service. Since journald stores log data in a binary format instead of a plaintext format, journalctl is the standard way of reading log messages processed by journald.

### Boot messages
Journald tracks each log to a specific system boot.
```
$ journalctl -b
```
You can view messages from an earlier boot by passing in its offset from the current boot.
```
$ journalctl -b -1
```
```
$ journalctl --list-boots
```

#### Time ranges
```
$ journalctl --since "1 hour ago"
```
```
$ journalctl --since yesterday
```
```
# format the date and time as “YYYY-MM-DD HH:MM:SS”
$ journalctl --since "2022-01-26 23:15:00" --until "2022-01-26 23:20:00"
```
### Unit
To see messages logged by any systemd unit, use the following command:
```
$ journalctl -u nginx.service
```
Multiple services example:
```
$ journalctl -u nginx.service -u mysql.service
```
### Follow or Tail outputs
Journalctl can print log messages to the console as they are added,similar to tail command.
```
$ journalctl -f
```
```
$ journalctl -u mysql.service -f
```
```
$ journalctl -n 50 --since "1 hour ago"
```
### User
To find all messages related to a particular user, use the UID for that user. 
```
$ id mysql
```
This returns a line like this.
```
uid=108(mysql) gid=116(mysql) groups=116(mysql)
```
And then we are querying the journal for all messages logged by that user.
```
# journalctl _UID=108
```

