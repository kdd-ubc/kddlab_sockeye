#!/bin/bash
 
#PBS -l walltime=0:20:00,select=1:ncpus=1:mem=2gb
#PBS -N kdd_sockeye_demo                           
#PBS -A pr-kdd-1                               
#PBS -m abe                                   
#PBS -M rtkushner@alumni.ubc.ca              
#PBS -o /scratch/pr-kdd-1/rt/kddlab_sockeye/output.txt
#PBS -e /scratch/pr-kdd-1/rt/kddlab_sockeye/error.txt
 
################################################################################
 
# load your modules
module load python3

cd /arc/project/pr-kdd-1/rt/kddlab_sockeye

#consume your envs, activate environments
source testvenv/bin/activate


#run your code here
python3 experiment_parser.py --outdir /scratch/pr-kdd-1/rt/kddlab_sockeye/ -it 100
