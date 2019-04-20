#!/bin/bash

killall -9 rofi

lock_icon="$HOME/scripts/resources/lock-icon.png"
tmpbg='/tmp/screen.png'

rectangles=" "

SR=$(xrandr --query | grep ' connected primary' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*')
for RES in $SR; do
  SRA=(${RES//[x+]/ })
  CX=$((${SRA[2]} + 25))
  CY=$((${SRA[1]} - 80))
  rectangles+="rectangle $CX,$CY $((CX+260)),$((CY-80)) "
done

scrot $tmpbg
convert "$tmpbg" -scale 50% \
 -fill black -colorize 15% \
 -blur "0x4" \
 -scale 200% \
 -draw "fill black fill-opacity 0.4 $rectangles" $tmpbg
convert "$tmpbg" "$lock_icon" -gravity center -composite -matte "$tmpbg"


i3lock \
  -e -i "$tmpbg" \
  --timepos="$CX+90:$CY-45" \
  --datepos="$CX+90:$CY-10" \
  --clock --datestr "%A, %d %b %Y" \
  --insidecolor=00000000 --ringcolor=ffffffff --line-uses-inside \
  --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --separatorcolor=00000000 \
  --insidevercolor=fecf4dff --insidewrongcolor=d23c3dff \
  --ringvercolor=ffffffff --ringwrongcolor=ffffffff --indpos="$CX+220:$CY-30-8" \
  --radius=20 --ring-width=3 --veriftext="" --wrongtext="" \
  --timecolor="ffffffff" --datecolor="ffffffff" \
  --noinputtext="";


# i3lock-fancy

rm -f $tmpbg;
rm -f $tmpbgfifo;
