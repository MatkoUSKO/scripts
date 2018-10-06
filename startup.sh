#!/bin/bash

# set keyboard repeat delay and keyboard repeat
xset r rate 180 50

# set background
feh --bg-scale ~/wallpapers/IMG_0197.JPG

# kill all click.sh processes running before and start new
killall -9 click.sh
`dirname "$0"`/click.sh & disown

# lock computer after few minutes of inactivity
killall -9 xautolock
xautolock -time 4 -locker `dirname "$0"`/lock_screen.sh & disown

killall -9 clipmenud
clipmenu/clipmenud & disown
