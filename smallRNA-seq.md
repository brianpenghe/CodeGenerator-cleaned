This is the smallRNA-seq pipeline instruction:

# 0. Set up the codes of generating scripts

You can create a soft link to all the scripts and genome references in the ~phe folders if you haven't never done that.

`ln -s ~phe/programs ~/programs; ln -s ~phe/genomes ~/genomes`

# 1. Run the code-generation pipeline

## 1.1 Organize the fastq files in subfolders

If there are only fastq.gz files in subfolders, run gunzip */*.gz to extract them

The files you have should look like this

![image](https://user-images.githubusercontent.com/4110443/178153762-ae941bc3-4258-4217-a7ae-7f6daf70cf85.png)

## 1.2 Create a file list (filename 'test' here)

One simple way to do it is `ls > test` and delete the line containing 'test'

The 'test' file should contain all the folder names

![image](https://user-images.githubusercontent.com/4110443/178153900-076cb443-f173-4a13-892f-fffee9aebcf2.png)

## 1.3 Run the code generator

~/programs/LocalCodeGeneratorYichengpiRNA.sh test dm6 0 SE

`test` is the file containing all the folder names. `dm6` is the name of the reference genome. `0` is to indicate using default trimming parameters. `SE` means single-ended (paired-end reads are currently not supported for this tutorial). 

Then you should see these messages after cleaning old files and generating script files.

![image](https://user-images.githubusercontent.com/4110443/178153973-7dda5fdd-f049-4eb5-8a06-02b043515eef.png)


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

### 2.1.2 Paste filtering and trimming codes
The trimming codes are stored in the file named `testcode`, which also contains other commands.

To read it more conveniently, you can download the `testcode` file to your local computer or move to your public directory and read from a browser.

Copy the part for trimming (see highlighted below, one command line for one file) and paste them into the terminal to start trimming.

![image](https://user-images.githubusercontent.com/4110443/178154056-76f0f5fc-37d9-4ac4-bf61-7adc4c83ba4b.png)

The commands will run in parallel, which you can inspect by typing `htop` (or `top` or `lsof ./` if no htop installed).

![image](https://user-images.githubusercontent.com/4110443/178154249-63262ae6-303c-4aa3-a46b-128f9dfd9dc0.png)


## 2.2 Align 23-29mers and 21-22mers to genome and vectors

### 2.2.1 Submit bowtie commands using condor

After 2.1 finishes, run these four commands:
```
#genome
condor_submit bowtie220710dm6_21_22.condor  
condor_submit bowtie220710dm6_23_29.condor
#vectors
condor_submit bowtie220710dm6_21_22.3.condor
condor_submit bowtie220710dm6_23_29.3.condor
```

After job submission, you can inspect the running threads using `condor_q`

### 2.2.2 Index alignment files

After 2.2.1 finishes run
```
./testcodePostBowtie
./testcodePostBowtie3
```

These will index the bam files


