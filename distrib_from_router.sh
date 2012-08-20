#!/bin/sh

# TODO: mail notification about errors

# Path to store subdirectories with playlists and videos on router.
# Their names must be the same as frames' hostnames (SB701013 for example)
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
# $1 - frame ip-address 
# $2 - directory/frame name
send_content(){
	# do some tests
	if [ ! -d $SRCDIR/$2/video ]
	then 
		error "directory \"video\" for frame $2 does not exist!"
		exit 1
	fi

	if [ ! -d $SRCDIR/$2/playlist ]
	then 
		error "directory \"playlist\" for frame $2 does not exist!"
		exit 1
	fi

	if [ ! -e $SRCDIR/$2/crontab ]
	then 
		error "crontab for frame $2 does not exist!"
		exit 1
	fi

	# upload _all_ files to frame (video, playlists, crontab)
	rsync -azv --delete -e ssh $SRCDIR/$2/* root@$1:$TRGTDIR
	if [[ $? == 0 ]]
	then
		success "content on frame $2 with $1 address updated"
	else
		error "sending files to frame $2 with address $1 failed!"
		exit 1
	fi

	# update cron jobs on frame
	ssh root@$1 "crontab $TRGTDIR/crontab"
	if [[ $? == 0 ]]
	then
		success "crontab on frame $2 with $1 address updated"
		touch $SRCDIR/$2.success
	else
		error "updating cron jobs on frame $2 with address $1 failed!"
		exit 1
	fi

	sleep 1
}

####################################################
# main cycle
cd $SRCDIR

for dir in `ls $SRCDIR`
do
	if [ -d $dir ] # only if it is directory
	then
		echo "processing $dir directory..."
		ip=`grep $dir $LEASES | awk '{print $3}'`
		if [[ $ip != "" ]]
		then
			#echo fake_sending $ip
			send_content $ip $dir
		fi
	fi
done


