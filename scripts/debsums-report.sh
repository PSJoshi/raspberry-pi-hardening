#!/bin/bash
echo "Generating debsums report"
echo ""
echo "Checking only config files. Getting only error reports"
/usr/bin/debsums -s -e | grep -i FAIL >>> /usr/local/scripts/log/debsum.log
echo "Checking only changed config files (not missing files)"
/usr/bin/debsums -c -e | grep -i FAIL >>> /usr/local/scripts/log/debsum.log
