This is the totalRNA-seq/RIP-seq pipeline instruction:
# 0. Set up the codes of generating scripts

You can create a soft link to all the scripts and genome references in the ~phe folders if you haven't ever done that.

`ln -s ~phe/programs ~/programs; ln -s ~phe/genomes ~/genomes`

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
For total RNA-seq:
`~/programs/LocalCodeGeneratorYichengTotalRNAseq.sh test dm6 50 SE`

For RIP-seq:
`~/programs/LocalCodeGeneratorYichengCLIP.sh test dm6 50 SE`

`test` is the file containing all the folder names. `dm6` is the name of the reference genome. `50` is the read length to trim to. `SE` means single-ended (paired-end reads are currently not supported for this tutorial). One thing to notice is that, although this pipeline uses R1 of paired-end reads for analysis as single-end reads, some protocols of strand-specific totalRNA-seq reads the fragment from R2, which is on the opposite strand. To account for that, manual flipping of the strand +/- may be necessary.

Then you should see these messages after cleaning old files and generating script files.

![image](https://user-images.githubusercontent.com/4110443/177877172-ae479abf-d0c9-44f3-b9ce-27a6aabb7d04.png)

# 2. Run the actual code
## 2.1 Trim reads in fastq files

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

## 2.2 Ribosomal RNA removal

After all the trimming commands finish after inspection, start running bowtie alignment codes stored in the .condor file

`condor_submit bowtie_rRNA220707.condor`

After job submission, you can inspect the running threads using `condor_q`

![image](https://user-images.githubusercontent.com/4110443/178102982-949586bf-64dc-4a71-aa4e-4333c1bbeb54.png)

After the commands finish running, you will see the files for unmapped reads (`*_unmapped.fastq`) which are the input for the next step.


## 2.3 Non-rRNA alignment

### 2.3.1 Run alignment codes

`condor_submit STAR220707.condor` submits commands to run STAR (please check your file name, which depends on the date).

### 2.3.2 Run bedgraph generation codes

After 2.3.1 is finished, run `condor_submit bedgraph220707.condor`

### 2.3.3 Run mapping stats codes

After 2.3.1 is finished, copy-paste the codes for STAR stats extraction from the `testcode` file.

![image](https://user-images.githubusercontent.com/4110443/178122093-6056ced4-b90c-4872-8caa-55f9dbc64e51.png)

The stats will be saved in `STATstat` that can be copy-pasted into an Excel file.


## 2.4 Rsem quantification based on STAR alignment

### 2.4.1 Run Rsem

After 2.3.1 finishes, you can run `condor_submit Rsem220707.condor` in parallel to 2.3.2 or not, to get gene and transcript counts.

### 2.4.2 Extract Rsem quantification table

After 2.4.1 finishes, you can organize Rsem quantifications of genes and transcripts into tables.

The codes to do that are also stored in the file `testcode`.

![image](https://user-images.githubusercontent.com/4110443/178122374-5f0ee47d-afdb-4861-9627-0fb69c7f59dc.png)

The tables will be named `rsem_FPKM_genes.tsv`, `rsem_count_genes.tsv`, `rsem_FPKM_isoforms.tsv`, and `rsem_count_isoforms.tsv`.

## 2.5 Vector alignment

### 2.5.1 Align non-rRNA reads against vectors

`condor_submit bowtie220707dm6_50.3.condor` submits bowtie commands to the server.

Please make sure to use the `.3.condor` file instead of other scripts with similar filenames.

### 2.5.2 Index alignment files

`./testcodePostBowtie3`

![image](https://user-images.githubusercontent.com/4110443/178122694-6d141299-e803-4d87-9fbe-c82e7c9a106f.png)

### 2.5.3 Generate bin counts

After commands in 2.5.2 finish, run `bash ~phe/programs/piRNA_PostProcess_50.sh` to generate bg4 files of bin counts.

This will call Deeptools that require a python3 environment. Please make sure your current environment has python3 as the default version of python

### 2.5.4 Get bowtie mapping stats

After 2.5.2 finishes, bowtie mapping stats can be extracted by running `./testcodePostBowtieStat220707dm6_50`

![image](https://user-images.githubusercontent.com/4110443/178123643-96ee8817-4a7a-4836-b684-ba57d7be5c96.png)

The stats will be stored in the output file `statsGenome220707dm6_50` and `statsVector220707dm6_50`

## 2.6 Vector dual mapping

After Step 2.5 finishes, you can move all the useful files from Vector mapping to a separate folder, and change the parameter of your bowtie script to repeat the Step 2.5. The command below changes `-m 1` to `-m 2`.

`sed -i 's/-v 0 -a -m 1 -t/-v 0 -a -m 2 -t/g' bowtie220707dm6_50.3.condor`

Then, follow the Steps 2.5.1 to 2.5.4 for dual mapping.
