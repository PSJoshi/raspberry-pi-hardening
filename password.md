### Change password expiry date
```
# change password expiry info for all the user(s)
# good ref: https://www.thegeekstuff.com/2009/04/chage-linux-password-expiration-and-aging/
# disable password aging
  #chage -m 0 -M 99999 -I -1 -E -1 <user>
  #sudo /usr/bin/chage -E "2025-12-01" -M 30000 -W 30 -I 10 $u 
for u in $user_info
do
    echo $u
    sudo /usr/bin/chage -M 5000 $u
    chage -l $u
done
```

### Password expiry
Root user (system administrators) can set the password expiry date for any user.
```
# chage -M 10 <user_name>
```
-M will update both “Password expires” and “Maximum number of days between password change” entries

You can also change password expiry using date. Date should be in “YYYY-MM-DD” format.
```
# chage -E "2009-05-31" dhinesh
```

Typically if the password is expired, users are forced to change it during their next login. You can also set an additional condition, where after the password is expired, if the user never tried to login for 10 days, you can automatically lock their account using option -I as shown below. In this example, the “Password inactive” date is set to 10 days from the “Password expires” value.

```
# chage -I 10 <user_name>
```

### Find linux accounts that have been inactive in the last 90 days
```
# lastlog -b 90 | awk '!/Never log/ {if (NR > 1) print $1}' |  xargs -I{} usermod -L {}
```

