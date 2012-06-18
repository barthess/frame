#!/bin/sh

main(){
	while [ 1 ]
	do
		sleep 2
		ssh root@192.168.42.51 'killall S11netkeep.sh'
		ssh root@192.168.42.51 'rm /etc/init.d/S11netkeep.sh'
	done
}

# To run in the background automatically (without & on the commandline) 
if [ "x$1" != "x--" ]; then
$0 -- 1> /dev/null 2> /dev/null &
exit 0
fi

main
