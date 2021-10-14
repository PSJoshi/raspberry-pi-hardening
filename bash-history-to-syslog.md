### Send bash history logs of all the users to syslog
Add the following to the file - /etc/profile
```
#log all your bash commands to syslog
function log2syslog
{
   declare COMMAND
   COMMAND=$(fc -ln -0)
   logger -p local1.notice -t bash -i -- "${USER}:${COMMAND}"
}
trap log2syslog DEBUG
```

### References:
* https://blog.rootshell.be/2009/02/28/bash-history-to-syslog/
* https://samsclass.info/honey/monitoring.html
* https://gist.github.com/JPvRiel/df1d4c795ebbcad522188759c8fd69c7
