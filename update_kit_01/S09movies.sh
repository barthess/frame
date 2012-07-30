#!/bin/sh

/usr/bin/lua /root/app.lua &
sleep 1
sw_plist sale
sleep 1
# run one more time to remove vertical gree
# stripes on the sides of the screen
sw_plist sale

