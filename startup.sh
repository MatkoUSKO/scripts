#!/bin/bash

# set up displays
xrandr --output HDMI-0 --pos 0x560 --dpi 80 --output DVI-D-0 --pos 1920x0 --dpi 96

# set keyboard repeat delay and keyboard repeat
xset r rate 180 50

# set background
feh --bg-fill ~/wallpapers/IMG_0197.JPG

# kill all click.sh processes running before and start new
killall -9 click.sh
`dirname "$0"`/click.sh & disown

# lock computer after few minutes of inactivity
killall -9 xautolock
xautolock -time 4 -locker `dirname "$0"`/lock_screen.sh & disown
