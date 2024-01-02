This is the ChIP-seq pipeline instruction:
# 0. Set up the codes of generating scripts

You can create a soft link to all the scripts and genome references in the ~phe folders if you haven't ever done that.

`ln -s ~phe/programs ~/programs; ln -s ~phe/genomes ~/genomes`

# 1. Run the code-generation pipeline
## 1.1 Organize the fastq files in subfolders
If there are only fastq.gz files in subfolders, run `gunzip */*.gz` to extract them

The files you have should look like this

![image](https://github.com/brianpenghe/CodeGenerator/assets/4110443/de9a822b-a975-48a2-8366-369a204b7f15)


## 1.2 Create a file list (filename 'test' here)
One simple way to do it is `ls > test` and delete the line containing 'test'

The 'test' file should contain all the folder names

![image](https://github.com/brianpenghe/CodeGenerator/assets/4110443/0a8de9c2-7241-4be3-86df-dbd41e9b1452)


## 1.3 Run the code generator


`~/programs/LocalCodeGeneratorYichengChIP.sh test dm6 50 SE`

`test` is the file containing all the folder names. `dm6` is the name of the reference genome. `50` is the read length to trim to. `SE` means single-ended (paired-end reads are currently not supported for this tutorial). One thing to notice is that, although this pipeline uses R1 of paired-end reads for analysis as single-end reads, some protocols of strand-specific totalRNA-seq reads the fragment from R2, which is on the opposite strand. To account for that, manual flipping of the strand +/- may be necessary.

Then you should see these messages after cleaning old files and generating script files.

![image](https://github.com/brianpenghe/CodeGenerator/assets/4110443/88ec019d-501a-4a5b-a965-54745eb6f2f9)

# 2. Run the actual code
## 2.1 Trim reads in fastq files

The codes for fastq trimming and other tasks are stored in the file named `testcode`.

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

The commands will run in parallel, which you can inspect by typing `htop` (or `top` or `lsof ./` if no htop installed).

![image](https://user-images.githubusercontent.com/4110443/177880770-7fdf79ec-52e6-43c8-b8d6-8b15310af312.png)

## 2.2 Uniquely align to genome and vectors

### 2.2.1 Run alighment codes

After 2.1 finishes, run these four commands:
```
#genome

condor_submit bowtie231117.14.19.22.504931482.condor
#vectors

condor_submit bowtie231117.14.19.22.504931482.2.condor
```

After job submission, you can inspect the running threads using `condor_q`


### 2.2.2 Index alignment files

After 2.2.1 finishes, run these
```
./testcodePostBowtie
./testcodePostBowtie2
```

These will index the bam files

You may also explore peak callers for ATAC-seq data using eRange, F-seq, HOMER, hotspot2 etc. These codes were stored in `testcode*`

### 2.2.3 Extract mapping stats

Run these commands after mapping is finished
```
./testcodePostBowtieStat231117.14.19.22.504931482
```

## 2.3 Downstream analysis

### 2.3.1 Calculate enrichment profiles

You will use the template below to call bamCompare. Create an `Enrichment.sh` file (you can type `nano Enrichment.sh`) and then make it executable by `sudo chmod a+rwx`.

The template is here:

```
#!/bin/sh
#define sample names
Input1=Sample_22822_ChIP_input_1_Sample_22822_ChIP_input_1.dm3.50mer.unique.dup.nochrM.bam
ChIP1=Sample_22823_ChIP_IP_1_Sample_22823_ChIP_IP_1.dm3.50mer.unique.dup.nochrM.bam
Input2=Sample_22824_ChIP_input_2_Sample_22824_ChIP_input_2.dm3.50mer.unique.dup.nochrM.bam
ChIP2=Sample_22825_ChIP_IP_2_Sample_22825_ChIP_IP_2.dm3.50mer.unique.dup.nochrM.bam

#two commands below, each for one pair of sample+input.
/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCompare -b1 $ChIP1 -b2 $Input1 \
    -of "bigwig" -o $ChIP1.Enrichment.bigWig --binSize 10 -bl \
     /woldlab/castor/proj/genome/bowtie-indexes/dm3-blacklist.bed -p 8 &
/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCompare -b1 $ChIP2 -b2 $Input2 \
    -of "bigwig" -o $ChIP2.Enrichment.bigWig --binSize 10 -bl \
     /woldlab/castor/proj/genome/bowtie-indexes/dm3-blacklist.bed -p 8 &
```

### 2.3.2 Make bedgraph files

Similarly, create a `bedgraph.sh` file using this template:

```
#!/bin/sh
ls *vectoronly*.bam | rev | cut -d. -f2- | rev > bams

for i in 10 100 1000
    do 
        while read bam
            do 
              /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage \
             -b $bam.bam  -of bedgraph -bs $i -o $bam.$i.bg4 
              /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage \
             -b $bam.bam  -of bedgraph -bs $i --samFlagInclude 16 -o $bam.$i.Minus.bg4
              /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage \
             -b $bam.bam  -of bedgraph -bs $i --samFlagExclude 16 -o $bam.$i.Plus.bg4
            done<bams
    done

for i in 10 100 1000
    do
        ls *.$i.*bg4 > bg4.$i.list
        while read bg4
            do
                awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bg4 > signal.bed
                bedops --chop $i signal.bed | bedmap --echo --echo-map-score - signal.bed \
                       | sed -e 's/|/\t/g' > $bg4.chopped.bg4
            done<bg4.$i.list
    done
```

### 2.3.3 Calculate transposon coverage

Similarly, create a `transposon.sh` file using this template:

```
#!/bin/bash
 for i in 10 50 100 500 1000
do
while read bam
do
/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam  -of bedgraph -bs $i --region chr2
R:6256844-6499214  -o $bam.$i.42AB.bg4; /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b
 $bam  -of bedgraph -bs $i --region chr2R:2144349-2386719  --samFlagInclude 16 -o $bam.$i.42AB.Minus.bg4; 
/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam  -of bedgraph -bs $i --region chr2
R:6256844-6499214  --samFlagExclude 16 -o $bam.$i.42AB.Plus.bg4

/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam  -of bedgraph -bs $i --region chrX
:21521148-21560880  -o $bam.$i.20A.bg4; /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b
 $bam  -of bedgraph -bs $i --region chrX:21392175-21431907  --samFlagInclude 16 -o $bam.$i.20A.Minus.bg4;
/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam  -of bedgraph -bs $i --region chrX
:21521148-21560880  --samFlagExclude 16 -o $bam.$i.20A.Plus.bg4

awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bam.$i.42AB.Minus.bg4 > signal.bed; bedops --chop $i signal.bed | bedma
p --echo --echo-map-score - signal.bed | sed -e 's/|/\t/g' > $bam.$i.42AB.Minus.bg4chopped.bg4;
awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bam.$i.42AB.Plus.bg4 > signal.bed; bedops --chop $i signal.bed | bedmap
 --echo --echo-map-score - signal.bed | sed -e 's/|/\t/g' > $bam.$i.42AB.Plus.bg4chopped.bg4;
awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bam.$i.42AB.bg4 > signal.bed; bedops --chop $i signal.bed | bedmap --ec
ho --echo-map-score - signal.bed | sed -e 's/|/\t/g' > $bam.$i.42AB.bg4chopped.bg4;

awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bam.$i.20A.Minus.bg4 > signal.bed; bedops --chop $i signal.bed | bedmap
 --echo --echo-map-score - signal.bed | sed -e 's/|/\t/g' > $bam.$i.20A.Minus.bg4chopped.bg4;
awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bam.$i.20A.Plus.bg4 > signal.bed; bedops --chop $i signal.bed | bedmap 
--echo --echo-map-score - signal.bed | sed -e 's/|/\t/g' > $bam.$i.20A.Plus.bg4chopped.bg4;
awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bam.$i.20A.bg4 > signal.bed; bedops --chop $i signal.bed | bedmap --ech
o --echo-map-score - signal.bed | sed -e 's/|/\t/g' > $bam.$i.20A.bg4chopped.bg4;


done<<<$(ls *dm6.50mer.unique.dup.bam)
done

```


