#!/bin/bash
Year=`date -d 2/02/2020 +%Y`
Month=`date -d 2/02/2020 +%m`
Day=`date -d 2/02/2020 +%d`
Hour=`date -d 2/02/2020 +%H`
Minute=`date -d 2/02/2020 +%M`
Second=`date -d 2/02/2020 +%S`
echo `date -d 2/02/2020`
echo "Current Date is: $Day-$Month-$Year"
echo "Current Time is: $Hour:$Minute:$Second"
