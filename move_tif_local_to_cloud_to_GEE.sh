##############################################################################################################
# Written By Diego Ellis Soto
# 
# Move files from my local computer to a bucket in Google Cloud
# Move that created folder from the bucket in google cloud to google earth engine
# 
#
#
#
##############################################################################################################
#
#
#
echo '(1) 	Move .tif files form my local computer to the bucket in Google Cloud Platform'
PATH_to_bucket=gs://data.earthenv.org/SDM_tifs_Cory_workflow
echo 'Inside the folder Maxent, every species is stored in a separate folder'
PATH_to_tifs_local_computer="/Users/diegoellis/Desktop/CORY_WORKFLOW_SDM/Palmas/test/Maxent/"
cd $PATH_to_tifs_local_computer
echo 'Store the name of each directory in a text file, it stores the chracters ./ which I will get rid of with awk'
echo 'Any of these will do'
find . -type d > list_of_files
ls > List_day.txt
echo "Now read each line of the text file to open the folder with that name and move all the .tif files inside of that folder to the desired bucket in google cloud plattform"

# LOOP THROUGH
for species in $(cat List_day.txt )  ; do # For each unique day
	cd $species # Change the directory
echo 'Moving all .tif files, models'
gsutil cp *.tif gs://data.earthenv.org/SDM_tifs_Cory_workflow
done


################################################################################################
for species in $(cat List_day.txt )  ; do
echo "$species"
echo 'Moving all .tif files, models for' "$species"
gsutil cp *.tif gs://data.earthenv.org/SDM_tifs_Cory_workflow
done
	cd $species # Change the directory
	gsutil cp *.tif gs://data.earthenv.org/SDM_tifs_Cory_workflow
done
################################################################################################




while read list_of_files;
do
filename=$(basename $list_of_files)
filename_no_tif_extention=${filename/\.tif/}    # remove the .tif extention # Regular expressio 
#      echo "$TIF_NAMES"
echo $filename
done


echo earthengine upload image --asset_id $PATH_TO_GEE/$filename_no_tif_extention --pyramiding_policy "sample" $INDIR/$filename
earthengine upload image --asset_id $PATH_TO_GEE/$filename_no_tif_extention --pyramiding_policy "sample" $INDIR/$filename
done</Users/diegoellis/Desktop/files_in_topography.txt








echo 'Copy all .tif files witihn a folder in my local computer to the desired Bucket in Google Cloud Platform'
gsutil cp *.tif gs://data.earthenv.org/SDM_tifs_Cory_workflow

