#!/bin/bash
# This script manages session timeout.
# touch /etc/profile.d/log-out.sh

cat > /etc/profile.d/log-out.sh << "EOF"
#!/bin/bash
# Log out in 2 minutes if the session is idle
export TMOUT=120
readonly TMOUT

# If you wish different timeout(s) for different user
# Log out in 2 minutes if the session is idle
#if [ `id -nu` == "root" ];then
#   export TMOUT=120
#   readonly TMOUT
#elif [ `id -nu` == <user> ];then
#   export TMOUT=60
#   readonly TMOUT
#fi

EOF
