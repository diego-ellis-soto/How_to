echo 'TEST DO MPI ON PARALLEL'
echo 'Inspired after Ben Carlsons how to:'

# Test do MPI parallel 

echo 'First test doMPI interactively'
srun --pty -p interactive -n 4 bash #request four tasks in the interactive queue
srun --pty -p interactive -n 4 --mem=32g bash # ask for 32 G 

module load Apps/R
module load Apps/R/3.3.2-generic # maybe use newer R instead of just R # Also maybe not install the packages but rather just load cmsdm and MOLSDM
module load Rpkgs/DOMPI
module load Rpkgs/RGDAL
module load Libs/GSL
mpirun -n 4 R --slave -f test_Chelsa_doMPI.R #use mpi run to kick off the script using four parallel processes
mpirun -np 1 #only start script on one task

echo 'Second run doMPI on a batch script'


#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=diego.ellissoto@yale.edu
#SBATCH -p day
#SBATCH --output doMPI-%j.out
#SBATCH -t 23:59:59
#SBATCH -n 50
#SBATCH --mem-per-cpu=32G
module load Apps/R/3.3.2-generic
module load Rpkgs/RGDAL
module load Libs/GSL
module load Rpkgs/DOMPI
cd /home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa
R --slave -f CHELSA_v1_hummingbird.R

nano test_Chelsa_doMPI.sh
#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=diego.ellissoto@yale.edu
#SBATCH -p day
#SBATCH --output doMPI-%j.out
#SBATCH -t 23:59:59
#SBATCH -n 50
#SBATCH --mem-per-cpu=32G
module load Apps/R/3.3.2-generic
module load Rpkgs/RGDAL
module load Libs/GSL
module load Rpkgs/DOMPI
cd /home/fas/jetz/de293/project/MPYC/code/sdm_code/hummingbirds_code/Chelsa
R --slave -f test_Chelsa_doMPI.R
