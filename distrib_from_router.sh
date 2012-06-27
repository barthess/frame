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
# $1 - frame ip-address (and directory name at the same time)
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
	rsync -azv -e ssh $SRCDIR/$1/* root@$1:$TRGTDIR
	if [[ $? == 0 ]]
	then
		success "content on frame with $1 address updated"
	else
		error "sending files to frame $1 failed!"
		exit 1
	fi

	# update cron jobs on frame
	ssh root@$1 "crontab $TRGTDIR/crontab"
	if [[ $? == 0 ]]
	then
		success "crontab on frame with $1 address updated"
		touch $SRCDIR/$1.success
	else
		error "updating cron jobs on frame $1 failed!"
		exit 1
	fi

	exit 0
}

####################################################
# main cycle
echo starting...

for dir in `ls $SRCDIR`
do
	echo "processing $dir directory..."
	if [ -d $dir ]
	then
		send_content $dir
	fi
done


