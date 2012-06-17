#!/bin/sh

# need to restart network AND ntpdate


ROUTER=192.168.42.1

reconnect(){
	echo ""
}

while [ 1 ]
do
	sleep 5
	ping $ROUTER -w5 -c1

	
	if [[ $? != 0 ]]
	then
		echo "reconnect"
	else
		echo "ok"
	fi
done


