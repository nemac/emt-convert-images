#!/bin/sh
for f in gif/*.gif
   do
     echo "Processing $f"

    fname=$(basename $f .gif)
    convert $f  -type Grayscale bw/raw/$fname.gif

done


for f in png/*.png
   do
     echo "Processing $f"

    fname=$(basename $f .png)
    convert $f  -type Grayscale bw/raw/$fname.png

done


mogrify -format tif -path bw/ bw/raw/*.png
mogrify -format tif -path bw/ bw/raw/*.gif
