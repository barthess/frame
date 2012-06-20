#!/bin/sh

ROUTER=192.168.42.1
PERIOD=15

main(){
	while [ 1 ]
	do
		sleep $PERIOD
		traceroute $ROUTER
	done
}

# To run in the background automatically (without & on the commandline) 
if [ "x$1" != "x--" ]; then
$0 -- 1> /dev/null 2> /dev/null &
exit 0
fi

main
