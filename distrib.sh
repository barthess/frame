#!/bin/sh

# TODO: Usage:

# Local path containing subdirectories with playlists and videos.
# Their names must be the same as frames' hostnames (SB701013 for example)
# and must contain 2 subdirectories: "playlist" and "video"
LOCAL=/home/tmp/router/content

# remote path to router to store video for
# later distribution to frames
ROUTERIP=router
ROUTERPATH=/root/testvideo

# Path on frame to store content
FRAMEPATH=/tmp

############################################################
# transfering files to router

echo -e "Uploading files to router... \c"
rsync -az -e ssh $LOCAL/* $ROUTERIP:$ROUTERPATH

if [[ $?==0 ]]
then
	echo "SUCCESS!"
else 
	echo "FAILED!"
	exit
fi
echo "----------------------------------------"

#####################################################
# redistributing files to each frame

# dhcp leases file on router
LEASES=/tmp/dhcp.leases

# send content to appropriate frame via rsync over ssh
# $1 - frame name
# $2 - frame ip-address
send_content(){
	echo -e "Trying to send files to frame $1 with $2 address... \c"

	ssh router "rsync -az -e ssh $ROUTERPATH/$1/ root@$2:$FRAMEPATH"
	if [[ $? == 0 ]]
	then
		echo "SUCCESS!"
	else
		echo "FAILED!"
	fi
}

# get leases from router to local computer
echo -e "Obtaining dhcp.leases file from router... \c"
scp -q $ROUTERIP:$LEASES /tmp
echo "SUCCESS!"

# redistribution cycle
for dir in `ls $LOCAL`
do
	ip=`grep -E " $dir " /tmp/dhcp.leases | awk '{print $3}'`
	if [[ $ip != "" ]]
	then
		send_content $dir $ip
	else
		ERRORS=1
		echo "**** ERROR! $dir not found in dhcp.leases"
	fi
done

# delete unneeded file
rm /tmp/dhcp.leases

# final message
echo "-------------------------------------------"
if [[ $ERRORS != 0 ]]
then
	echo "There were some errors during content redistribution to frames."
else
	echo "Updating finalized without errors."
fi

