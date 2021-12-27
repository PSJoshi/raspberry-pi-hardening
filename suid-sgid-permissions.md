### Setting SUID and SGID permissions
SUID is a special file permission for executable files which enables other users to run the file with effective permissions of the file owner. Instead of the normal x which represents execute permissions, you will see an s (to indicate SUID) special permission for the user.

SGID is a special file permission that also applies to executable files and enables other users to inherit the effective GID of file group owner. Likewise, rather than the usual x which represents execute permissions, you will see an s (to indicate SGID) special permission for group user.

### Find all the files with SGID and SUID permissions set
```
# find / -perm /6000 -exec ls -l {} \;
```
###  Find all the files with SGID permissions set
```
#  find / -perm /2000 -exec ls -l {} \;
```

###  Find all the files with SUID permissions set
```
#  find / -perm /4000 -exec ls -l {} \;
```

Ref:
* https://www.liquidweb.com/kb/how-do-i-set-up-setuid-setgid-and-sticky-bits-on-linux/
