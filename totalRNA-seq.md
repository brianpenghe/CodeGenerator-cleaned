This is the totalRNA-seq pipeline instruction:

# 1. Run the code-generation pipeline
## 1.1 Organize the fastq files in subfolders
If there are only fastq.gz files in subfolders, run `gunzip */*.gz` to extract them

The files you have should look like this

![image](https://user-images.githubusercontent.com/4110443/177864540-a9130db6-c91e-4225-999e-63b839e625e0.png)

## 1.2 Create a file list (filename 'test' here)
One simple way to do it is `ls > test` and delete the line containing 'test'

The 'test' file should contain all the folder names

![image](https://user-images.githubusercontent.com/4110443/177876758-f870fc07-d086-4d87-9fb3-b17b9db6bcbb.png)

## 1.3 Run the code generator

`~/programs/LocalCodeGeneratorYichengTotalRNAseq.sh test dm6 50 SE`

`test` is the file containing all the folder names. `dm6` is the name of the reference genome. `50` is the read length to trim to. `SE` means single-ended (pair-ended reads are currently not supported for this tutorial).

Then you should see these messages after cleaning old files and generating script files.

![image](https://user-images.githubusercontent.com/4110443/177877172-ae479abf-d0c9-44f3-b9ce-27a6aabb7d04.png)

# 2. Run the actual code
## 2.1 Run fastq trimming
The codes for fastq trimming and other tasks are stored in the file named 'testcode'.

### 2.1.1 Use the screen commands
#### 2.1.1.0 Introduction
Screen is a method to let time-consuming commands run without needing to connect to the server all the time.

A detailed description can be found [here](https://linuxize.com/post/how-to-use-linux-screen/).

A screen is like a dream created in [Reception](https://www.imdb.com/title/tt7311298/). It runs by itself but depends on your physical world (the running server). It can also read and write your files directly.

The five most useful screen commands are:

1. To create a screen session named 'Yicheng' and enter it, `screen -S Yicheng`

2. To exit a screen session, ctrl + a then d

3. To re-enter a screen session, `screen -r Yicheng` or `screen -r` when there's only one session

4. To re-enter an attached screen session (some other tabs connected to it etc.), `screen -dr Yicheng`

5. To scroll up and down in a screen session, ctrl + a then press Esc. Press again to exit scrolling mode

#### 2.1.1.1 Enter a screen
Make sure you are inside a screen (ctrl + a then press d to exit). If not or exited, re-enter using the 3rd or 4th command introduced above. 

### 2.1.2 Paste trimming codes
The trimming codes are stored in the file named `testcode`, which also contains other commands.

To read it more conveniently, you can download the `testcode` file to your local computer or move to your public directory and read from a browser.

Copy the part for trimming (see highlighted below, one command line for one file) and paste them into the terminal to start trimming.

![image](https://user-images.githubusercontent.com/4110443/177880258-53638f9e-db7d-449f-b2dd-bb4fcede8883.png)

The commands will run in parallel, which you can inspect by typing `htop` (or `top` or `lsof ./` if no htop installed).

![image](https://user-images.githubusercontent.com/4110443/177880770-7fdf79ec-52e6-43c8-b8d6-8b15310af312.png)

## 2.2 Run rRNA mapping codes
After all the trimming commands finish after inspection, start running bowtie alignment codes stored in the .condor file

`condor_submit bowtie_rRNA220707.condor`

After job submission, you can inspect the running threads using `condor_q`

![image](https://user-images.githubusercontent.com/4110443/178102982-949586bf-64dc-4a71-aa4e-4333c1bbeb54.png)

After the commands finish running, you will see the files for unmapped reads (`*_unmapped.fastq`) which are the input for the next step.

## 2.3 Run non-rRNA mapping codes

`condor_submit tophat220707.condor` submits commands to run STAR (please check your file name, which depends on the date).

## 2.4 Run Rsem quantification and bigWig generation codes

After 2.3 finishes, these two commands can be submitted together since they do not depend on each other.

`condor_submit bedgraph220707.condor`

`condor_submit Rsem220707.condor`
