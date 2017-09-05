echo 'Moving the newest workflow MOLSDM-master-5 and cmsdm-master-6 to Grace Next'
# Connect to Grace Next
ssh -X -Y de293@grace-next.hpc.yale.edu
# Set up a new folder for the Yale Max Planck Center for  research computing,
# specifically for sdms currently
cd project
mkdir MPYC # Make a new folder for the max planc yale center
cd MPYC
mkdir data # to store .csv points, .shapefiles and .rasters of different species
mkdir env_data # To store remote sensing layers such as Chelsa in there
mkdir packages # TO store R packages in there among others
mkdir code # Rscript and bash script,e tc wil be stored here
cd code
mkdir sdm_code
mkdir log_files # Log files will be stored here
mkdir hummingbirds_code # For hummingbirds put a bash file asking for workers, 
# an r script with make data file whih prepares and reprojects my data (v2_make*.r) and v1_Hummingbirds_HPC.r which runs the workflowMOL
cd ..
cd data
mkdir sdm # here I will put all my data for different species gorups
mkdir mol_refinements # In here I will put the elevaiton limits and land cover preferences. 
#I want to keep this folder separate from SDM folder as it might be used for something different
mkdir elevation_gmted_tiffs # Here I will store tif files of information 
#(I make an exception of not moving it to env_data here because I would only use it for the modeling.)
# For RS data i would rather use SRTM or so.
cd sdm
mkdir hummingbirds
cd hummingbirds
mkdir output # I want a species group specific folder to store my outputs (SDMs, etc)
mkdir output/domains
mkdir output/rDists
echo 'Now move the points, shapefiles and rasters of hummingbirds to the payh in the hpc'
echo 'Open a new terminal. I like having two separate terminals open (one for being on hpc Grace Next, the other one using my local computer to move things into grace)'
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Points de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Expertmap_raster de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Expertmap_shapefile de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/ExpertShpProjected de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds
echo 'Move folders with Cory Merows workflow'
scp -r /Users/diegoellis/Downloads/cmsdm-master-6 de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/packages
scp -r /Users/diegoellis/Downloads/MOLSDM-master-5 de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/packages
echo 'Move the folder with MOL_refinements to HPC. This folder contains a .csv file describing eelvaiton range limits for a vast amount of species'
echo 'Move elevation folder containing tiffs of gmted with max min elevation'
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/MOL_Refinements de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/mol_refinements
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Elev de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/elevation_gmted_tiffs
echo 'Move customized R scripts to GRACE next (I like to do them locally first because I have a GUI)'
scp /Users/diegoellis/projects/v1_Hummingbirds_HPC.r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code
scp /Users/diegoellis/projects/v2_make_Hummingbirds_HPC.r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code
scp /Users/diegoellis/projects/v3_humingbird.R de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code
echo 'Make a bash file asking for workers'
echo 'Save it as hummingbird_HPC.sh'
#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=diego.ellissoto@yale.edu
#SBATCH --output doPar-%j.out
#SBATCH -t 24:00:00
#SBATCH -n 8
#SBATCH --mem-per-cpu=10G
module load Tools/SlurmNodes
module load Apps/R/3.3.2-generic
module load Rpkgs/RGDAL
module load Libs/GSL

cd /home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code
R --slave -f v1_Hummingbirds_HPC.r

echo 'I like to run an interactive R session first to see if things are atually working'
echo 'Start an interactive session for 1 day asking for 32 gb'
srun -p  interactive --mem-per-cpu 32768 --pty bash

 module load Tools/SlurmNodes
module load Apps/R/3.3.2-generic
module load Rpkgs/RGDAL
module load Libs/GSL
R

echo 'Now im in R and can copy paste my scirpts'
echo 'After I got one hummignbord working running thre workflow interactively, I downlaod the pdf generated on the hpc to look at it on the local computer'
echo 'I can also look at the pdf on the hpc with'
evince /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_1_hummingbird/Figures/Abeillia_abeillei_maps_v1.pdf
scp de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_1_hummingbird/Figures/Abeillia_abeillei_maps_v1.pdf /Users/diegoellis/Desktop

echo 'Move a subset of hummignbds only 20. to a separate folder to speed things up'
scp -r /Users/diegoellis/Desktop/Only_20 de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbird_subset


echo 'I updated my foreach loop with clusterExport: '
scp /Users/diegoellis/projects/development/Half_earth/Grace_sdm/Half_Earth/v1_Hummingbirds_HPC.r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code

 sbatch hummingbirds.sh 
 cat /home/fas/jetz/de293/project/MPYC/code/sdm_code/log_files/try_7_hummingbird.log # Check what the status is of thr workflow, where are things breaking/not breaking
ls /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_7_hummingbird/Figures/ # Check if figures are being made
evince  /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_7_hummingbird/Figures/Amazilia_cyanura_maps_v1.pdf 
evince /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_7_hummingbird/Figures/Aglaeactis_castelnaudii_maps_v1.pdf 

ls -l | wc -l /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_7_hummingbird/Figures/ # Check if figures are being made
echo 'Check how many models have been generaded'
echo 'A total of ' ls -l /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_7_hummingbird/Figures/ | wc -l ' have been generated so far'

scancel 3263871 # cancel a job with a job id

echo 'I want 16GB in interactive mode'
srun --pty -p interactive --mem-per-cpu 32768 -t 48:00 bash
sbatch -t 72:00 --mem-per-cpu 32768 Hummingbird_20170707.sh 
cat /home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/doPar-3265161.out

cd /home/fas/jetz/de293/project/MOL/CHELSA/
mkdir CHELSA_subset
cp *bio12*.tif CHELSA_subset/
cp *bio_15*.tif CHELSA_subset/
cp CHELSA_bio_1.tif  CHELSA_subset/
cp CHELSA_bio_2.tif CHELSA_subset/


cat /home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/doPar-3265161.out

cd /home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/ # Where my scripts are
cd /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/

cd /home/fas/jetz/de293/project/MOL/CHELSA/

edcho 'Now for my chelsa run'
 cd /home/fas/jetz/de293/project/MOL/CHELSA/CHELSA_subset/ # Has my env data
 cd /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbird_subset/Only_20/
echo 'Move my scripts for Chelsa'
scp /Users/diegoellis/projects/development/Half_earth/Grace_sdm/Half_Earth/CHELSA_v1_hummingbird.R de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa
scp /Users/diegoellis/projects/development/Half_earth/Grace_sdm/Half_Earth/CHELSA_v2_make_hummingbird.R de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa
scp /Users/diegoellis/projects/development/Half_earth/Grace_sdm/Half_Earth/v5_Chelsa.R de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa


ls project/MPYC/data/sdm/hummingbirds/output/try_2_hummingbird_chelsa/Figures/
echo 'New strategy: Split the code into 2: One that ends with sorting species and the other one that starts with laoding allBaseDir and sortSpecies MOL and just runs the workflow'

scp /Users/diegoellis/projects/development/Half_earth/Grace_sdm/Half_Earth/v8_hummingbird_step_by_step_1.R de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/
scp /Users/diegoellis/projects/development/Half_earth/Grace_sdm/Half_Earth/v8_hummingbird_step_by_step_2.R de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/


cat /home/fas/jetz/de293/project/MPYC/code/sdm_code/log_files/try_14_hummingbird.log # check this log file
ls -l /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_14_hummingbird/Figures/ | wc -l 
ls -l /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_2_hummingbird/Figures/ | wc -l 
ls -l /home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_2_hummingbird_chelsa/Figures/ | wc -l 
cd /home/fas/jetz/de293/project/MPYC/code/sdm_code/ # check this log file
ls /home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa/
cat /home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa/doPar-3285599.out 

echo 'Download the models generated by Chelsa and move to my dropbox folder'
scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_2_hummingbird_chelsa /Users/diegoellis/Desktop
scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_2_hummingbird_chelsa_inputs /Users/diegoellis/Desktop


scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_21_noparallel_hummingbird /Users/diegoellis/Desktop
scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_21_noparallel_hummingbird_inputs /Users/diegoellis/Desktop

scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_20_noparallel_hummingbird /Users/diegoellis/Desktop
scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_20_noparallel_hummingbird_inputs /Users/diegoellis/Desktop

scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_24_noparallel_hummingbird /Users/diegoellis/Desktop
scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_24_noparallel_hummingbird_inputs /Users/diegoellis/Desktop

scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_25_noparallel_hummingbird /Users/diegoellis/Desktop
scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_25_noparallel_hummingbird_inputs /Users/diegoellis/Desktop

scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_40_noparallel_hummingbird /Users/diegoellis/Desktop
scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_40_noparallel_hummingbird_inputs /Users/diegoellis/Desktop
########################################################################################################################
echo BASIC HPC COMMANDS NOW


echo 'ssh to grace' -> de293@grace1 # I enter login node number 1
ssh -X -Y de293@grace-next.hpc.yale.edu
echo 'Allocate a compute node, dont work on the login node...'
srun --pty  bash # Set up a connection between bash and where I am now
srun --pty -p interactive bash # I want an interactive partition (-p)
# c01n01  CHassie 1 node 1
echo Say I want to run R
echo To load software load it with module
module load R
 module avail | less
 module avail | python # shows me everything that has to do with python
module avail gromacs 
module avail R
module avail Apps/RSTUDIO/1.0.136
echo 'Max of interactive R session is one day!'
exit # exit the interactive session
# defualt interactive is one core on one node....
srun --pty -p interactive bash
 srun --pty -p interactive -c 10 bash # I can ask for 10 cores
 # default memory is... 5GB ! one core 
 srun --pty -p interactive --mem=8g bash
srun --pty -p interactive --mem=8g bash
# EACH NODE has maimum of...
# general partition for bash jobs can use 100 CPU and 640GB ram. -> CHECK REQUIREMENTS OF GRACE!



load this bash script. allways good to coment a bash script:

#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=robert.bjornson@yale.edu
#SBATCH -t 3:00 # 3 minutes
#SBATCH --mem=10g

module load R

Rscript myscript.R
echo run a batch script: sbatch batch.sh
sbatch -p general -J myjob batch.sh  # run on gneeral partiiton, its the default anyway
# -J give the job a name (myjob) if not it will have the name of the batch script. 



cyberduck is pretty good graphical Tools
rsync is good cuz will only copy what needs to be copied like a time machine. 


# for private partition we can just 


sinfo -p general # how busy is the cluster: shows all nodes avaialble for general partition


echo 'How muc memory does my job need'
sacct -J 3285599 -l | less -S # Can scroll back and ford through the line
# JobIRaw jobid.bat+ batch is the line that mathers -> MaxVMSize -> Says how much memory it used.
-c -n -N
-N: Forces job to scheduled onto N nodes rarely useful
-c: cores: Specifies how many cores has each task. 
This is how many CPUs I want

-n: Specifies tasks -> Normally only usefull with MPI. Allmost never use little n

sbatch -c A single 20 core task on 1 node: I want a whole 20 core node to myself
sbatch -c 20 -n 4:  I want four 20 core tasks on multiple nodes
# I want four tasks with twenty cores per task. This is only useful for mpi. 

sbatch -n 40: I want 40 1-core takss, spread among nodes. 

module load Apps/Gurobi/7.0.1

sbatch -c 8 --mem-per-cpu=20G t.sh  # Per core I want 20 gigabyes
-mem-8g # all cores to share 8gb
# command line will overwrite. 

# graphical stuff on HPC: Maybe a separate tutorial for this? 



PARALLEL R: (1) Parallelize a single thing.
# [1]# create a task list file of what I want to do one per line -> ....
# I have 300 tasks in them... run an R script zB workflowMOL
# [2]]# load deadsimple quee as a module. module load dSQ
# [3] give it the task file (tasklist.txt) and say how much memory per cpu you want
dSQ --task  tasklist.txt --mem-per-cpu=4g
# [4] # will generate a batch script called runsq.sh
dSQ --task  tasklist.txt --mem-per-cpu=4g > runsq.sh
 # [5] submit the job 
 sbatch runsq.sh
# [6] check for the jobs
squeue -l -u de293
# [7] can do for a thousand complicated jobs! 
# [8] check the status and exactly how many tasks worked/failed.
dSQAutopsy tasklist.txt job_ID_status.tsv
# prints how many jobs worked and tells me exactly which files failed.
echo 'Try to use this! Is scalable and adatable.'

echo 'I can directly use a task array as an alternative'
vi array.sh # Will run N copies of exactly this script, only difference is the SLURM_ARRAY_TASK_ID (each time this will change for instance for a different species name)

https://github.com/ycrc

# going beyond -c 20 is a challenge! -> Need MPI! \# MPI
# !bin/bash
#SBATCH -n 20 # thats how many tasks / workers MPI is going to have. 
mpirun ./mpiprogram
module load MPI/OpenMPI





ssh -X -Y de293@yale....
xterm # check if x11 is installed
exit # exit x11
srun --pty -p interactive --x11 bash
xterm
module load Tools/RSTUDIO
RSTUDIO
# how to ask for 256 --big-mem 256G
squeue -u de293 -l


echo 'Move newest workflow to this:'
scp -r /Users/diegoellis/Downloads/cmsdm-master-7 de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/packages2
scp -r /Users/diegoellis/Downloads/MOLSDM-master-6 de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/packages2


echo 'So workflow worked with bigmem'
echo Put all hummingbird models into my directory

scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_help_from_YCRC_33334_hummingbird /Users/diegoellis/Desktop

scp -r de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/output/try_help_from_YCRC_33334_hummingbird_inputs /Users/diegoellis/Desktop

echo Move PSEM map types to HPC:

echo UNDO: I JUST RERUN ALL PSEM AGAIn!!!
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Expert_Map_Types/ahull_conservative de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/PSEM
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Expert_Map_Types/ahull_liberal de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/PSEM
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Expert_Map_Types/ahull_middleground de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/PSEM
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Expert_Map_Types/country de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/PSEM
scp -r /Users/diegoellis/projects/MOL/diego_hummingbirds/Expert_Map_Types/mcp de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/data/sdm/hummingbirds/PSEM


echo 'Preparing CHELSA STEP'
scp /Users/diegoellis/projects/development/Half_Earth/
scp /Users/diegoellis/projects/development/Half_earth/Grace_sdm/Half_Earth/CHELSA_HPC_v1_hummingbirds_prepare_data.R de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa
scp /Users/diegoellis/projects/development/Half_earth/Grace_sdm/Half_Earth/CHELSA_HPC_v2_hummingbirds_make_SDM de293@grace-next.hpc.yale.edu:/home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa

