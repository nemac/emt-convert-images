#!/bin/sh
for f in png/*.png 
   do
     echo "Processing $f"

    #rename to remove spaces...
    mv "$f" "${f// /_}"
    mv "$f" "${f//-/_}"
    mv "$f" "${f//__/_}"

    fname=$(basename $f .png)
    #gdal_calc.py --NoDataValue=0 -A $f --A_band=1 -B $f --B_band=2 -C $f --C_band=3 $f --outfile=out_tif/$fname.tif --calc="A+B+C"
    gdal_calc.py -A $f --A_band=1 -B $f --B_band=2 -C $f --C_band=3 $f --outfile=out_tif/$fname.tif --calc="(A+B+C)+1"

done
