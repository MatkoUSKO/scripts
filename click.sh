#!/usr/bin/bash

WIDTH=125; #random values
HEIGHT=125; #random values
WINDOW=-1; #random values

while :
do
  eval $(xdotool search --class "messenger for desktop" getwindowgeometry --shell);
  WIDTH=$(expr $X + $WIDTH / 2);
  HEIGHT=$(expr $Y + $HEIGHT - 15);
  if [[ $WINDOW -eq $(xdotool getactivewindow) ]]; then
    xdotool mousemove --sync $WIDTH $HEIGHT click 1 mousemove 'restore';
    while [[ $WINDOW -eq $(xdotool getactivewindow) ]]; do
      sleep 0.3;
    done;
  fi
  sleep 0.5;
done;
