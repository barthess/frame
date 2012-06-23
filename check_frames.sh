#!/bin/sh

# IPLIST="192.168.42.13 192.168.42.175 192.168.42.23 192.168.42.61 192.168.42.51" 
# LOGFILE=/root/frames.log
# PERIOD=1800

IPLIST="192.168.42.119 192.168.42.175" 
LOGFILE=/tmp/frames.log
PERIOD=5

touch $LOGFILE

main(){
	while [ 1 ]
	do
		sleep $PERIOD
		for i in $IPLIST
		do
			ping $i -c1
			
			if [[ $? != 0 ]]
			then
				echo "$i OFFLINE -- `date`" >> $LOGFILE
			# else
			# 	echo "$i OK      -- `date`" >> $LOGFILE
			fi
		done
	done
}

# To run in the background automatically (without & on the commandline) 
if [ "x$1" != "x--" ]; then
$0 -- 1> /dev/null 2> /dev/null &
exit 0
fi

main
