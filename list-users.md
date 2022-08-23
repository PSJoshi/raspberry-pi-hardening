#### List current users
```
# who
```
#### List last logged-in
```
# last
```
#### List non-system users
```
# eval getent passwd "{$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)}" | cut -d: -f1
```
#### List root users
```
# getent group | grep 'x:0:' /etc/passwd | cut -d: -f1
```
#### List sudoers
```
# getent group root wheel adm admin | cut -d: -f4
```

#### List users with shells
```
# getent passwd | awk -F/ '$NF != "nologin" && $NF != "false" && $NF != "sync" && $NF != "!"' | cut -d: -f1 |sort |uniq
```

#### List system services
```
# systemctl list-units --all --type=service --no-pager
```

#### Find a service file
```
# find / -name coredns.service 2> /dev/null
```

