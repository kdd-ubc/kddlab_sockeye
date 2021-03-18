

# Preliminaries

- Contacte Sockeye Admin to get access to your supervisor's allocation. (Ours is ex-kdd-1)
- Most likely will have to [ install a VPN ](https://it.ubc.ca/services/email-voice-internet/myvpn) if working off campus. 
https://it.ubc.ca/services/email-voice-internet/myvpn


- you can log into sockeye via ```ssh <yourcwl>@sockeye.arc.ubc.ca```

- once you are in, please create a folder with your name in SCRATCH and PROJECT and work from there. :)

- a note on the directory structure:
```
/
├─ /home/<cwl>
├─ arc/project/ex-kdd1/     <--------  Queue jobs from PROJECT
│  ├─ .../
│  ├─ <cwl>/demo/demo.job.sh
├─ /scratch/ex-kdd-1/       <--------  Write output files to SCRATCH
│  ├─ .../
│  ├─ <cwl>/demo_results/results.csv

```




# General Workflow:

## 1.Transport input data & code to sockeye.

```
rsync -zpr  myexperimentfiles mycwl@sockeye.arc.ubc.ca:/project/ex-kdd-1/myuserfolder/
```
or 
```
scp -r  myexperimentfiles mycwl@sockeye.arc.ubc.ca:/project/ex-kdd-1/myuserfolder/
```

## 2.Set up your experiment's environment

Could imply many things, but in general:
  
  - define environmental variables you'd like to use
  - create a virutal environment in the case of python. (In PROJECT)
  - create an incipient folder structure in output (In SCRATCH)
  

## 3.Create a job script.

Most things require loading software packages from ARC's directories prior to any work being done. Only ```gcc``` is loaded by defalt.

You can inspect available and and load the needed modules via:

```module avail```

```module load <module name>```

It pays to be mindful of versioning. 


A good overview of a PBS script is given [ here ](https://confluence.it.ubc.ca/display/UARC/Running+Jobs). 

In particular, line **#PBS -l walltime=1:00:00,select=1:ncpus=1:mem=2gb** says that you are requesting **1 node**(select=1) with **1cpu**(ncpus=1) and **2gb of memory**(mem=2gb) and are expecting it to run for roughly **1 hour**(walltime=1:00:00,eyeballing this usually; 72 hours is the limit).

```bash
#!/bin/bash
 
#PBS -l walltime=:00:00,select=1:ncpus=1:mem=2gb              <-----see above
#PBS -N thursday_demo                                         <-----the name with which the job will show up in the queue
#PBS -A ex-kdd-1                                              <-----This is our "allocation code". You have to tag on a "-gpu" for gpu jobs: 'ex-kdd-1-gpu
#PBS -m abe                                                   <-----modes of logging
#PBS -M your.name@ubc.ca                                      <-----specify the email via which PBS will inform you about completion/failure of this job
#PBS -o /scratch/ex-kdd-1/yourname/demo_results/output.txt
#PBS -e /scratch/ex-kdd-1/yourname/demo_results/error.txt
 
################################################################################
 
# load your modules
module load python3

cd /arc/project/ex-kdd-1/yourname/
#consume your envs, activate environments

#run your code here

 
```

## 4.Submit your job, monitor its status; kill an erroneous submission.


Submit your scrip via :```qsub myjob.sh ```

See its status in the queue :```qstat ``` or ```qstat | grep <yourcwl>```

If mistaken is made or job unwanted :```qdel <jobid:12332144.pbsha ```

## 5.Export results out of Sockeye


```
scp -r   mycwl@sockeye.arc.ubc.ca:/project/ex-kdd-1/myuserfolder/myexperimentalresults user@youmachine:~/myexperimentalresults
```


----- 


## Docs 

General Documentation : https://confluence.it.ubc.ca/display/UARC/UBC+ARC+Technical+User+Documentation#app-switcher

Guides, more specific documentationt:https://confluence.it.ubc.ca/#all-updates

## Known issues 

- Don't forget to ```module load``` your package managers.
- ```pip install``` is best done as ```--user``` such that there are no permissions conflicts. (Better yet, create a ```venv``` in advance and outside of the job script)
- Make sure no used software logs or caches things outside of ```scratch```. (Matplotlib, cupy ex.)

