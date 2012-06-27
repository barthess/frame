#!/bin/sh

IP="frame23 frame13 frame31 frame32 frame51 frame61 frame52 frame62"

####################################################
# main cycle
for ip in $IP
do
	ssh $ip 'sed /etc/init.d/S25ntpdate.sh -e "s/sleep 30/sleep 60/" > /tmp/S25ntpdate.sh; cp /tmp/S25ntpdate.sh /etc/init.d/S25ntpdate.sh'

	if [[ $? == "" ]]
	then
		echo "$ip done"
	else
		echo "$ip failed with status $?"
	fi
done

# final message
echo "--------------------------------------------------"
