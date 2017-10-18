!/bin/sh 
for f in gif/*.gif
   do 
     echo "Processing $f"

    #rename to remove spaces...
    mv "$f" "${f// /_}"
    mv "$f" "${f//-/_}"
    mv "$f" "${f//__/_}"
    
    fname=$(basename $f .gif)
    #gdal_calc.py --NoDataValue=0 -A $f --A_band=1 --outfile=out_tif/$fname.tif --calc="A"
    gdal_calc.py  -A $f --A_band=1 --outfile=out_tif/$fname.tif --calc="A+1"

done
