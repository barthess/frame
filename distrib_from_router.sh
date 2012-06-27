#!/bin/sh

# TODO: mail notification about errors

# Path to store subdirectories with playlists and videos on router.
# Their names must be the same us frames' hostnames (SB701013 for example)
# and must contain 2 subdirectories: "playlist" and "video"
SRCDIR=/mnt/sdcard/frames_content

# path on target frame to store content
# TRGTDIR=/tmp
TRGTDIR=/mnt/mtddisk

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

# rsync content to appropriate frames
# $1 - frame name
# $2 - frame ip-address
send_content(){
	# do some tests
	if [ ! -d $SRCDIR/$1/video ]
	then 
		error "directory \"video\" for frame $1 does not exist!"
		exit 1
	fi

	if [ ! -d $SRCDIR/$1/playlist ]
	then 
		error "directory \"playlist\" for frame $1 does not exist!"
		exit 1
	fi

	if [ ! -e $SRCDIR/$1/crontab ]
	then 
		error "crontab for frame $1 does not exist!"
		exit 1
	fi

	# upload _all_ files to frame
	rsync -az -e ssh $SRCDIR/$1/* root@$2:$TRGTDIR
	if [[ $? == 0 ]]
	then
		success "content on frame $1 with $2 address updated"
	else
		error "sending files to $1 failed!"
	fi

	# update cron jobs on frame
	ssh root@$2 "crontab $TRGTDIR/crontab"
	if [[ $? == 0 ]]
	then
		success "crontab on frame $1 with $2 address updated"
		touch $SRCDIR/$1.success
	else
		error "updating cron jobs on frame $1 failed!"
	fi
}

####################################################
# main cycle
for dir in `ls $SRCDIR`
do
	if [ -d $dir ]
	then
		ip=`grep -E " $dir " $LEASES | awk '{print $3}'`
		if [[ $ip != "" ]]
		then
			send_content $dir $ip
		else
			error "$dir not found in $LEASES"
		fi
	fi
done


