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
And then we can query the journal for all messages logged by that user.
```
# journalctl _UID=108
```
### Deleting old logs
If you use the --vacuum-size option, you can shrink your journal by indicating a size
```
#journalctl --vacuum-size=1G
```
You can also shrink the journal by providing a cutoff time with the --vacuum-time
```
# journalctl --vacuum-time=1years
```
### Common configuration options 
You can configure the server to place limits on how much space the journal can take up by editing ```/etc/systemd/journald.conf``` file.

Most common settings used to limit the journal growth are:
* SystemMaxUse - specifies the maximum disk space that can be used by the journal in persistent storage.
* SystemKeepFree - specifies the amount of space that the journal should leave free when adding journal entries to persistent storage.
* systemMaxFileSize - controls how large individual journal files can grow to in persistent storage before being rotated.
* runtimeMaxUse - specifies the maximum disk space that can be used in volatile storage (within the /run filesystem).
* runtimeKeepFree - specifies the amount of space to be set aside for other uses when writing data to volatile storage (within the /run filesystem).
* runtimeMaxFileSize - specifies the amount of space that an individual journal file can take up in volatile storage (within the /run filesystem) before being rotated.
