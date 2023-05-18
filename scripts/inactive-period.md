### Set inactive period

Run the following command and verify INACTIVE is 30 or less:
```
# useradd -D | grep INACTIVE
```
Run the following command to set the default password inactivity period to 30 days:
```
# useradd -D -f 30
```
Modify user parameters for all users with a password set to match:
```
# chage --inactive 30 <user>
```
Verify all users with a password have Password inactive no more than 30 days after password expires:
```
# egrep ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1
<list of users> 
```
```
# chage --list <user> 
Password inactive : <date>
```
