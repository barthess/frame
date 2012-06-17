#!/bin/sh

IP="frame13    frame164   frame175   frame51    frame61"

####################################################
# main cycle
for ip in $IP
do
	ssh $ip "echo 'openwrt' > /etc/ntpserver"
	if [[ $? == "" ]]
	then
		echo "$ip done"
	else
		echo "$ip failed with status $?"
	fi
done

# final message
echo "--------------------------------------------------"
