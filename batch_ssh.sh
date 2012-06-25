#!/bin/sh

IP="frame23 frame13 frame164 frame175 frame51 frame61 frame52 frame62"

####################################################
# main cycle
for ip in $IP
do
	scp S12netkeep.sh $ip:/root/
	ssh $ip '/root/S12netkeep.sh'
	if [[ $? == "" ]]
	then
		echo "$ip done"
	else
		echo "$ip failed with status $?"
	fi
done

# final message
echo "--------------------------------------------------"
