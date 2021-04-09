#!/bin/bash
 
#PBS -l walltime=72:00:00,select=1:ncpus=12:ompthreads=12:ngpus=2:mem=186gb
#PBS -N kdd_sockeye_demo                           
#PBS -A ex-kdd-1-gpu                              
#PBS -m abe                                   
#PBS -M rtkushner@alumni.ubc.ca              
#PBS -o /scratch/ex-kdd-1/rt/kddlab_sockeye/output.txt
#PBS -e /scratch/ex-kdd-1/rt/kddlab_sockeye/error.txt
 
################################################################################
 
# load your modules
module load gcc
module load cuda
module load python3

cd /arc/project/ex-kdd-1/rt/kddlab_sockeye

#consume your envs, activate environments
source testvenv/bin/activate

#run your code here
python3 experiment_parser.py --outdir /scratch/ex-kdd-1/rt/kddlab_sockeye/ -it 1000000
