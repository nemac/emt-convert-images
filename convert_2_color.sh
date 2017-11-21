#!/bin/sh

docker pull mdillon/postgis
docker build -t mdillon/postgis .
docker run -p 5439:5432 --name 'postgis' -d  -e POSTGRES_PASSWORD=mysecretpassword -v `pwd`/sql:/sql mdillon/postgis

rm shp/line/*.shp
rm shp/line/*.shx
rm shp/line/*.dbf
rm shp/line/*.prj

#wait 5 seconds for docker to complete
sleep 5

for f in shp/*.shp
   do
     echo "Processing $f"

    fname=$(basename $f .shp)
    line='_line'
    linefile=$fname$line
    finaltemp='_temp'
    finalfile=$fname$final

     #Convert a Floor Plan Shapefile
     echo "Convert shapefile to postgis"
    /Library/Frameworks/GDAL.framework/Versions/1.11/Programs/ogr2ogr -f "PostgreSQL" PG:"host=localhost port=5439 user=postgres dbname=template_postgis password=mysecretpassword" -lco GEOMETRY_NAME=geom -nlt PROMOTE_TO_MULTI -overwrite $f -nln "data"

    #Create a view of the data as a line
    echo "Create View"
    docker container exec postgis psql -U postgres -d template_postgis -f sql/convert_line.sql

    #Return results as valid linestring shapefile
    echo "convert to linestring shapefile"
    /Library/Frameworks/GDAL.framework/Versions/1.11/Programs/ogr2ogr -f "ESRI Shapefile" shp/line/$linefile.shp   PG:"host=localhost port=5439 user=postgres dbname=template_postgis password=mysecretpassword"  -overwrite -sql "select * from template_postgis.public.data_line"

    #Rasterize the line file
    echo "Rasterize line"
    gdal_rasterize -ot Byte -tr 1.5 1.5 -a val -l $linefile shp/line/$linefile.shp  final/temp/$finalfile.tif

    #Reverse the colors to get simple black and white
    echo "Reverse colors on image"
    convert final/temp/$finalfile.tif -negate final/$fname.tif

    echo "Drop view"
    docker container exec postgis psql -U postgres -d template_postgis -c 'DROP VIEW public.data_line;'


done

docker stop postgis && docker rm postgis
