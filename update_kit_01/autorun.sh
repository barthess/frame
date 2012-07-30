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

guilog "Installing public SSH keys"
rm -f /root/.ssh/*
cp /mnt/mmc/authorized_keys /root/.ssh

guilog "Updating network starting script"
cp /mnt/mmc/S10network /etc/init.d

sync
guilog "DONE. Unplug SD card now."
sleep 5

reboot


