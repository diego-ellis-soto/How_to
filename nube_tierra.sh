# This script moves data from google cloud into google earth
# define path to directories
INDIR=gs://data.earthenv.org/topography # Path of where the data is in google cloud
PATH_TO_GEE=projects/earthenv/topography # Path of where i want this to be stored in google earth$

# Get the names of all the files in google earth and store them in a text file 
gsutil ls $INDIR/*.tif > /Users/diegoellis/Desktop/files_in_topography.txt # Get me the name of all the files in google earth

TIF_NAMES=/Users/diegoellis/Desktop/files_in_topography.txt
# For each column in this file (each column is a separate .tif file

while read TIF_NAMES;
do
filename=$(basename $TIF_NAMES)
filename_no_tif_extention=${filename/\.tif/}    # remove the .tif extention # Regular expressio 
#      echo "$TIF_NAMES"
echo $filename
echo earthengine upload image --asset_id $PATH_TO_GEE/$filename_no_tif_extention --pyramiding_policy "sample" $INDIR/$filename
earthengine upload image --asset_id $PATH_TO_GEE/$filename_no_tif_extention --pyramiding_policy "sample" $INDIR/$filename
done</Users/diegoellis/Desktop/files_in_topography.txt
