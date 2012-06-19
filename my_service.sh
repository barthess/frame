#!/bin/sh /etc/rc.common
# Example script
# Copyright (C) 2007 OpenWrt.org
 
START=50
STOP=15
 
start() {        
	/root/app/clearframe.sh
}                 
 
stop() {          
	killall clearframe.sh 
}


