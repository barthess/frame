#!/bin/sh

# Y position for gui-echo
YPOS=160


guilog() {
    echo "$YPOS $1"
    gui-echo 0 $YPOS "$1"
    YPOS=$((YPOS+20)) 
}

cd /

guilog "Installing movie script"
cp /mnt/mmc/S09movies.sh /etc/init.d

guilog "Deleting old movie script"
rm -f /etc/init.d/S30app.sh

sync
guilog "DONE. Unplug SD card now."
sleep 5

reboot


