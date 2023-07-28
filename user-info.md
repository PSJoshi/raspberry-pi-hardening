* List root users
```
# getent group | grep 'x:0:' /etc/passwd | cut -d: -f1
```
* List non-system users
```
# eval getent passwd "{$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)}" | cut -d: -f1
```

* List sudoers
```
# getent group root wheel adm admin | cut -d: -f4
```
* List users with shell
```
# getent passwd | awk -F/ '$NF != "nologin" && $NF != "false" && $NF != "sync" && $NF != "!"' | cut -d: -f1
```
