* Clean command history
```
# history -c
```
* Permanently disable bash history
```
# echo 'set +o history' >> ~/.bashrc
```
* Disable command history system wide
```
# echo 'set +o history' >> /etc/profile
```
* Disable history for current shell
```
# set +o history
```
