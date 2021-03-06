#!/bin/sh

rm shp/*.shp
rm shp/*.shx
rm shp/*.dbf
rm shp/*.prj


for f in bw/*.tif
   do
     echo
     echo "Processing $f"

     ul1="$(gdalinfo $f | grep "Upper Left" | sed 's/.*(\(.*\))/\1/' | sed 's/ //g' | sed 's/,.*//')"
     ul2="$(gdalinfo $f | grep "Upper Left" | sed 's/.*(\(.*\))/\1/' | sed 's/ //g' | sed 's/.*,//')"

     ur1="$(gdalinfo $f | grep "Upper Right" | sed 's/.*(\(.*\))/\1/' | sed 's/ //g' | sed 's/,.*//')"
     ur2="$(gdalinfo $f | grep "Upper Right" | sed 's/.*(\(.*\))/\1/' | sed 's/ //g' | sed 's/.*,//')"

     ll1="$(gdalinfo $f | grep "Lower Left" | sed 's/.*(\(.*\))/\1/' | sed 's/ //g' | sed 's/,.*//')"
     ll2="$(gdalinfo $f | grep "Lower Left" | sed 's/.*(\(.*\))/\1/' | sed 's/ //g' | sed 's/.*,//')"

     lr1="$(gdalinfo $f | grep "Lower Right" | sed 's/.*(\(.*\))/\1/' | sed 's/ //g' | sed 's/,.*//')"
     lr2="$(gdalinfo $f | grep "Lower Right" | sed 's/.*(\(.*\))/\1/' | sed 's/ //g' | sed 's/.*,//')"

     echo "${ul1}"
     echo "${ul2}"

     echo "${ur1}"
     echo "${ur2}"

     echo "${ll1}"
     echo "${ll2}"

     echo "${lr1}"
     echo "${lr2}"

     fname=$(basename $f .tif)

     echo $fname

     rm out_tif/temp_bw.tif
     gdal_translate -of GTiff -gcp -0.00000000001 "${ll2}" -0.00000000001 -"${ll2}" -gcp "${lr1}" "${lr2}" "${lr1}" -"${lr2}" -gcp "${ur1}" -0.00000000001 "${ur1}" 0.00000000001 -gcp -0.00000000001  -0.00000000001 -0.00000000001 -0.00000000001 out_tif/$fname.tif out_tif/temp_bw.tif

     rm out_tif/temp_gw_bw.tif
     gdalwarp -r near -order 1 -co COMPRESS=NONE  "out_tif/temp_bw.tif" "out_tif/temp_gw_bw.tif"

     gdal_polygonize.py -f "ESRI Shapefile" out_tif/temp_gw_bw.tif shp/$fname.shp  -overwrite


done
