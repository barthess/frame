#!/bin/sh

ROUTER=192.168.42.1
PERIOD=60
TRYLIMIT=10
TRY=0

# save some debug information.
blackbox(){
	ls /dev -lar > /mnt/mtddisk/dev.log
	ifconfig -a > /mnt/mtddisk/ifconfig.log
}

# infinitely ping router every $PERIOD seconds
# if ping unsuccessful than try to reconnect
main(){
	while [ 1 ]
	do
		sleep $PERIOD
		ping $ROUTER -c1
		
		if [[ $? != 0 ]]
		then
			logger "netkeeper: trying to reconnect wi-fi"
			TRY=`expr $TRY + 1`
			blackbox
			/usr/sbin/restart_wifi
		else
			echo "connection ok"
			TRY=0
		fi

		if [[ $TRY == $TRYLIMIT ]]
		then
			echo 'exiting'
			exit
		fi
	done
}

# To run in the background automatically (without & on the commandline) 
if [ "x$1" != "x--" ]; then
$0 -- 1> /dev/null 2> /dev/null &
exit 0
fi

main
