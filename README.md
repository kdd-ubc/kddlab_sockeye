**Node types/priority heuristics**: https://confluence.it.ubc.ca/display/UARC/About+Sockeye

# Preliminaries

- NECESSARY: [Contact Sockeye Admin here](mailto:arc.support@ubc.ca),CC Khanh in the email to get access to the allocation. (Ours is pr-kdd-1)
 i.e. 
 
    **Hi, My name is X and my CWL is thus.

    I'm a researcher at Khanh Dao-Duc's(kdd@math.ubc) lab and require access to computational resources for my experiments. Is there any chance my account could be added to Khanh's group on Sockeye? Our allocation's code is <pr-kdd-1>. 

    Best,
    X**
    
  

- If you are outside of campus (i.e. not connect tot the __ubc-secure__ wifi network), you likely will have to [ install a VPN ](https://it.ubc.ca/services/email-voice-internet/myvpn).
They have [ an option for Windows ](https://it.ubc.ca/services/email-voice-internet/myvpn/myvpn-setup-windows) as well.

- you can then log into sockeye via ```ssh <yourcwl>@sockeye.arc.ubc.ca``` (You campus-wide login :: cwl is a login string granted to you by UBC when you were creating your account. You can find it easily in the Studen Service Centre for example)

- once you are in, please create a folder with your name in __SCRATCH__ and __PROJECT__ and work from there. More on these two folders late. :)
```
This is supposed to represent Sockeye's  filesystem available to the user(us).
Forward slash is the root directory from which you can navigate everywhere else:

/
├─ /home/<cwl>
|
├─ /arc/project/pr-kdd-1/     <--------  Queue jobs from PROJECT
│  ├─ .../
│  ├─ <YourFolder>/yourfiles.so
|
├─ /scratch/pr-kdd-1/        <--------  Direct your programs to write output files to SCRATCH
│  ├─ .../
│  ├─ <YourFolder>/demo_results/results.csv
```




# General Workflow:

## 1.Transport input data & code to sockeye.

```
rsync -zpr  myexperimentfiles mycwl@sockeye.arc.ubc.ca:/arc/project/pr-kdd-1/myuserfolder/
```
or 
```
scp -r  myexperimentfiles mycwl@sockeye.arc.ubc.ca:/arc/project/pr-kdd-1/myuserfolder/
```

## 2.Set up your experiment's environment

Could imply many things, but in general:
  
  - define environmental variables you'd like to use
  - create a virutal environment in the case of python. (In PROJECT)
  - create an incipient folder structure in output (In SCRATCH)
  
Most things require loading software packages from ARC's directories prior to any work being done. Only ```gcc``` is loaded by defalt.

You can inspect available and and load the needed modules via:

```module avail```

```module load <module name>```


![ image ](./Screenshot%20from%202021-04-22%2011-54-30.png)

It pays to be mindful of versioning. 

_______

Ex. to set up a python virtual environment, for example, you would have to load ```python3``` and some virtual environment manager, say  ```py-virtualenv/16.4.1-py3.7.3```:
```
$ module load python3 py-virtualenv/16.4.1-py3.7.3 
$ python3 -m virtualenv myenv
$ source myenv/bin/activate
(myenv)$ echo "Good to go!"
```


## 3.Create a job script.



A good overview of a PBS script is given [ here ](https://confluence.it.ubc.ca/display/UARC/Running+Jobs). 

In particular, line **#PBS -l walltime=1:00:00,select=1:ncpus=1:mem=2gb** 
 
says that you are requesting **1 node**(select=1) with **1cpu**(ncpus=1) and **2gb of memory**(mem=2gb) and are expecting it to run for roughly **1 hour**(walltime=1:00:00,eyeballing this usually; 72 hours is the limit).

```bash
#!/bin/bash
 
#PBS -l walltime=1:00:00,select=1:ncpus=1:mem=2gb             <-----see above
#PBS -N thursday_demo                                         <-----the name with which the job will show up in the queue
#PBS -A pr-kdd-1                                              <-----This is our "allocation code". You have to tag on a "-gpu" for gpu jobs: 'ex-kdd-1-gpu
#PBS -m abe                                                   <-----modes of logging
#PBS -M your.name@ubc.ca                                      <-----specify the email via which PBS will inform you about completion/failure of this job
#PBS -o /scratch/pr-kdd-1/yourname/someresultsfolder/output.txt
#PBS -e /scratch/pr-kdd-1/yourname/someresultsfolder/error.txt
 
################################################################################
 
# load your modules
module load python3

cd /arc/project/pr-kdd-1/yourname/
#consume your envs, activate environments

#run your code here

 
```


### GPU Job


Pretty much the same thing except:

  - have to tag the *-gpu* to the allocation code
  - request the actual resource (*gpus=20*)
  - ```module load``` ```cuda```

```bash
#!/bin/bash
 
#PBS -l walltime=1:00:00,select=1:ncpus=1:mem=2gb:gpus=20
#PBS -N demo_gpu
#PBS -A pr-kdd-1-gpu
#PBS -m abe
#PBS -M rtkushner@alumni.ubc.ca
#PBS -o /scratch/pr-kdd-1/rt/kddlab_sockeye/output.txt
#PBS -e /scratch/pr-kdd-1/rt/kddlab_sockeye/error.txt
 
################################################################################
 
# load your modules

module load gcc
module load cuda
module load python3

cd /arc/project/pr-kdd-1/yourname/
#consume your envs, activate environments

#run your code here
```

## 4.Submit your job, monitor its status; kill an erroneous submission.


Submit your scrip via :```qsub myjob.sh ```

See its status in the queue :```qstat ``` or ```qstat | grep <yourcwl>```

If mistaken is made or job unwanted :```qdel <jobid:12332144.pbsha> ```

## 5.Export results out of Sockeye


```
scp -r   mycwl@sockeye.arc.ubc.ca:/scratch/pr-kdd-1/myuserfolder/myexperimentalresults user@youmachine:~/myexperimentalresults
```


----- 


## Docs 

General Documentation : https://confluence.it.ubc.ca/display/UARC/UBC+ARC+Technical+User+Documentation#app-switcher

Guides, more specific documentationt:https://confluence.it.ubc.ca/#all-updates

## Known issues 

- Don't forget to ```module load``` your package managers.
- ```pip install``` is best done as ```--user``` such that there are no permissions conflicts. (Better yet, create a ```venv``` in advance and outside of the job script)
- Make sure no used software logs or caches things outside of ```scratch```. (Matplotlib, cupy ex.)

__________


## Useful for larger/more granular jobs:

[ GNU-parallel ](https://www.gnu.org/software/parallel/parallel_tutorial.html) is a useful utility if you are requesting multiple cores and there is obvious quick/dirty parallelization to take advantage of. It takes care of allocating sequential processes to the number of workers(cores) available to you without any configuration.

Another feauture that makes it useful is it's argument-passing interface. Sequences of arguments provided to parallel's template string ( ```{1} {2} etc.```)  (separated by ```:::```) are passed to the inner program that parallel wraps as cartesian products. Ex.:

```bash
$ parallel 'echo {1} {2} {3}' ::: x ::: y z ::: 1 2 3

x y 1
x y 2
x y 3
x z 1
x z 2
x z 3
```
This makes it quite convenient if you need to explore a space of multiple parameters. Likewise, if you are requesting a node with 10 cpus to run a 100 iterations of a script, delegating threading to ```parallel``` should make it 10 times faster (give or take).

```bash
#PBS -l walltime=1:00:00,select=1:ncpus=10:mem=32gb
#...

module load parallel

#...

parallel 'python3 experiment.py --save /disney/land/results --parameter {1} --iteration_id {2}' ::: linear quadratic cubic ::: $(seq 1 100)

```
---------------------


## PBS Array Jobs



For large series of jobs with very similar submission parameters it is highly recommended to make use of PBS array jobs. In this case a single job script can launch many jobs and change the execution parameters, such as input files, based on the array index within the job.


|||
|:---:|:---:|
|**#PBS -J 10-100:10**|	This flag identifies the job as an array job and sets the indexes to be used for the sub jobs. 10-100 in this case gives a range of 10 to 100 for subjob indexes. This range can be any set of positive values to identify the indexes. Following the range there is an optional parameter that can be provided to identify the increment step between each job index. In this case we use 10 so the job indexes will be : 10,20,30..100. If no increment parameter is provided the increment defaults to 1.|
|^array_index^|	During job submission time the PBS_ARRAY_INDEX environmental variable is not yet initialized. If you need to define the job array index during submission time the macro ^array_index^ can be used and will be replaced on job submission by the array ID. This is particularly useful if you wish to use PBS to control the standard output and error with the -o and -e flags and would like each subjob in the array to write to its own file.|
|**PBS_ARRAY_INDEX**	|During job execution this environment variable will contain the job array index number specific to the subjob. This can be used to map the job execution commands and parameters to the unique components for each sub job.|
  
Array job example script:

```bash
#!/bin/bash
#PBS -l walltime=3:00:00,select=1:ncpus=4:mem=16gb
#PBS -J 0-100:10
#PBS -N job_name
#PBS -A alloc-code
#PBS -o output_^array_index^.txt
#PBS -e error_^array_index^.txt
 
################################################################################
 
module load thisorthat
module load python3

#utilizing array job
python3 experiment.py --save /disney/land/results --parameter qubic --iteration_id $PBS_ARRAY_INDEX

#this can also be combined with gnu-parallel to split a long-parallel job into an array of smaller jobs that still utilize multiple gpus
parallel 'python3 experiment.py --save /disney/land/results --parameter {1} --iteration_id {2}' ::: linear quadratic cubic ::: $(seq $PBS_ARRAY_INDEX $(( $PBS_ARRAY_INDEX +10)))

```

_____

# Jupyter Notebooks

Consult [this doc](https://confluence.it.ubc.ca/display/UARC/Jupyter+Notebooks+with+Singularity) for running jupyter notebook interactively on a sockeye node. 


--https://confluence.it.ubc.ca/display/UARC/Jupyter+Notebooks+with+Singularity--












