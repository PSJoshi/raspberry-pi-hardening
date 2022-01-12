#!/bin/bash
echo "Audit reports:"
echo "Generating audit rules key(s) report"
aureport -k -i
echo ""
echo "Generating attempted authentication report"
aureport -au -i
echo ""
echo "Generating login information reports "
aureport -l
echo ""
echo "Generating failed summary report"
aureport --failed
echo ""
echo ""
echo "Generating summary report"
aureport -ts yesterday -te now --summary -i
echo ""

