#!/bin/sh

IP="frame23    frame13    frame164   frame175   frame51    frame61"

####################################################
# main cycle
for ip in $IP
do
	# scp S11netkeep.sh $ip:/etc/init.d/ 
	ssh  $ip '/etc/init.d/S11netkeep.sh'
	if [[ $? == "" ]]
	then
		echo "$ip done"
	else
		echo "$ip failed with status $?"
	fi
done

# final message
echo "--------------------------------------------------"
