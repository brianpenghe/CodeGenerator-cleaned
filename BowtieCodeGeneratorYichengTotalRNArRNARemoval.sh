#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed

#usage: ./BowtieCodeGeneratorYichengTotalrRNARemoval.sh testFolderPath dm3 30mer SE

CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

bowtiedate=$(date +"%y%m%d")
echo '' > bowtie_rRNA$bowtiedate".condor"
printf '''
universe=vanilla

executable=/bin/sh

log=shell.rRNA.$(Process).log
output=shell.rRNA.$(Process).out
error=shell.rRNA.$(Process).err

request_cpus = 8
request_memory = 4000
request_disk = 0

Requirements = (Machine == "pongo.caltech.edu" || Machine == "myogenin.caltech.edu" || Machine == "mondom.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.caltech.edu")

''' >> bowtie_rRNA$bowtiedate".condor"

while read line
    do
        if [[ "$4" == "PE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$rRNAbowtieindex" -p 8 -v 2 -k 1 --best -X 2000 -t --sam-nh -q -1 "$line"R1allfastq"$3" -2 "$line"R2allfastq"$3" --un "$line"allfastqrRNAUnmapped"$3".fastq "$line"allfastq.rRNA.mapped"$3".map 2> "$line"allfastq.rRNA.mapped"$3".err \' \"\nqueue\n" >> bowtie_rRNA$bowtiedate".condor"
        elif [[ "$4" == "SE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$rRNAbowtieindex" -p 8 -v 2 -k 1 --best -t --sam-nh -q "$line"allfastq"$3" --un "$line"allfastqrRNAUnmapped"$3".fastq "$line"allfastq.rRNA.mapped"$3".map 2> "$line"allfastq.rRNA.mapped"$3".err \' \"\nqueue\n" >> bowtie_rRNA$bowtiedate".condor"
        fi
    done <$1
