#!/bin/sh

# TODO: mail notification about errors

# Path to store subdirectories with playlists and videos on router.
# Their names must be the same us frames' hostnames (SB701013 for example)
# and must contain 2 subdirectories: "playlist" and "video"
SRCDIR=/tmp/content

# path on target frame to store content
TRGTDIR=/tmp/content

# dhcp leases file on router
LEASES=/tmp/dhcp.leases

# error flags
ERRORS=0

# error handler
error(){
	echo "ERROR: $1"
	# write message to syslog
	logger "content distributor ERROR: $1"
	ERRORS=1
}

# success handler
success(){
	# write message to syslog
	logger "content distributor SUCCESS: $1"
}

# send content to appropriate frame via ssh
# probably would be better to use rsync from frame side.
# $1 - frame name
# $2 - frame ip-address
send_content(){
	echo "Trying to send files to frame $1 with $2 address..."
	status=`scp -rp $SRCDIR/$1/* root@$2:$TRGTDIR`
	if [[ $? == 0 ]]
	then
		echo "	Success"
		success "frame $1 with $2 address updated"
	else
		error "sending files to $1 failed!"
	fi
}

####################################################
# main cycle
for dir in `ls $SRCDIR`
do
	ip=`grep -E " $dir " $LEASES | awk '{print $3}'`
	if [[ $ip != "" ]]
	then
		send_content $dir $ip
	else
		error "$dir not found in $LEASES"
	fi
done

# final message
echo "--------------------------------------------------"
if [[ $ERRORS != 0 ]]
then
	echo "There were some errors. See system log."
else
	echo "Updating finalized without errors."
fi
