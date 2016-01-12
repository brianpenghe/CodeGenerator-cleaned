#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed


#usage: ./tophatCodeGenerator.sh testFolderPath mm9 30mer
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2




echo '' >> testcode
echo "******take a break***********" >> testcode
echo "tophat.condor codes:" >> testcode
echo "********(checkout tophat condor file)*********" >> testcode

tophatdate=$(date +"%y%m%d")
printf '''
universe=vanilla

environment="PATH=$ENV(PATH):/woldlab/castor/home/georgi/programs/bowtie-0.12.9/:/woldlab/castor/home/georgi/programs/samtools-0.1.18:/woldlab/castor/home/georgi/programs/tophat-2.0.8.Linux_x86_64/"
getenv = true

executable=/bin/sh

log=tophat2.$(Process).log
output=tophat2.$(Process).out
error=tophat2.$(Process).err

request_cpus = 4
request_memory = 4000
request_disk = 0

Requirements = (Machine == "pongo.cacr.caltech.edu" || Machine == "myogenin.cacr.caltech.edu" || Machine == "mondom.cacr.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.cacr.caltech.edu")

''' >> bowtie$bowtiedate".condor"

while read path
    do
        printf "arguments=\"-c \' python /woldlab/castor/home/georgi/code/trimfastq.py "$path"allfastq "$3" -stdout | python /woldlab/castor/home/georgi/programs/tophat-2.0.8.Linux_x86_64/tophat -p 4  --GTF /woldlab/castor/home/georgi/genomes/mm9/Mus_musculus.NCBIM37.67.filtered.gtf --transcriptome-index /woldlab/castor/home/georgi/genomes/mm9/bowtie-indexes/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered  -o "$path"."$2"."$3"mer /woldlab/castor/home/georgi/genomes/mm9/bowtie-indexes/mm9-single-cell-NIST-fixed-spikes - \' \"\nqueue\n" >> tophat$tophatdate".condor"
    done <$1

