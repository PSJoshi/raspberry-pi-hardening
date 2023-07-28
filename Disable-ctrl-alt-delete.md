"masking" is a feature of systemd to prevent service activation.
```
# systemctl mask ctrl-alt-del.target
```
or
```
# ln -s /dev/null /usr/lib/systemd/system/ctrl-alt-del.target
```
#### Check if it's masked:
```
# systemctl list-unit-files --type target | grep ctrl
```

#### Remove mask:
```
# systemctl unmask ctrl-alt-del.target
```
