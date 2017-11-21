#!/bin/sh
for f in out_tif/*.tif
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

     rm /Users/daveism/bldg_floor_plans_emt/out_tif/temp.tif
     gdal_translate -of GTiff -gcp -0.00000000001 "${ll2}" -0.00000000001 -"${ll2}" -gcp "${lr1}" "${lr2}" "${lr1}" -"${lr2}" -gcp "${ur1}" -0.00000000001 "${ur1}" 0.00000000001 -gcp -0.00000000001  -0.00000000001 -0.00000000001 -0.00000000001 /Users/daveism/bldg_floor_plans_emt/out_tif/$fname.tif /Users/daveism/bldg_floor_plans_emt/out_tif/temp.tif

     rm /Users/daveism/bldg_floor_plans_emt/out_tif/temp_gw.tif
     gdalwarp -r near -order 1 -co COMPRESS=NONE  "/Users/daveism/bldg_floor_plans_emt/out_tif/temp.tif" "/Users/daveism/bldg_floor_plans_emt/out_tif/temp_gw.tif"

     gdal_polygonize.py -f "ESRI Shapefile"  /Users/daveism/bldg_floor_plans_emt/out_tif/temp_gw.tif shp/$fname.shp


done
