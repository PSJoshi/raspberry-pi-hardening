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
