#!/usr/bin/env bash

## Thanks to https://github.com/senid231/kde_4k_telegram_tray_icons/
## Variables ##
## After finishig this icons should be placed in $HOME/.local/share/TelegramDesktop/tdata/ticons

source=./telegram.png # icon source
font=Ubuntu # see 'identify -list font' for obtain the name of the font
messages=10 #number of the messages printed in the dot 
size=18 # size of the final image
dot_size=70 # meassure in % (smallest than the size)
font_size=145 # meassure in % (smallest than the dot size)
###############

cp $source icon_22_0.png
# Some Math
max="$(echo "scale=1; $size*($dot_size/100)" | bc)"
mid="$(echo "scale=1; $max/2" | bc)"
psize="$(echo "scale=1; $mid*($font_size/100)" | bc)"

# dot image in SVG format
dot="<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"${max}\" height=\"${max}\"><path d=\"M${max} ${mid}a${mid} ${mid} 0 1 1-${max} 0 ${mid} ${mid} 0 1 1 ${max} 0z\" style=\"fill:##\"/></svg>"

# Detect the display density
#dpi="$(xrdb -q | awk 'match($0, /Xft.dpi:\t([^ ]*)/, a) {print a[1];}')"
dpi=96
# Create the base image icon_22_0.png and iconmute_22_0.png
#convert -density $((dpi*2)) -background transparent -resize ${size} -trim "${source}" icon_22_0.png
cp icon_22_0.png iconmute_22_0.png

# Create the message counter images
for i in $(seq 1 $messages); do
  counter="\"##\""
  # Draw the number of the message number into the dot and compose the final image
  echo "${dot//##/#FF0000}" | convert -background transparent -gravity Center -font ${font} -pointsize ${psize}% -fill white -draw "text 0,0 ${counter//##/$i}" svg:- png:- | composite -density ${dpi} -gravity SouthEast png:- icon_22_0.png icon_22_${i}.png
  echo "${dot//##/#555555}" | convert -background transparent -gravity Center -font ${font} -pointsize ${psize}% -fill white -draw "text 0,0 ${counter//##/$i}" svg:- png:- | composite -density ${dpi} -gravity SouthEast png:- icon_22_0.png iconmute_22_${i}.png
done
