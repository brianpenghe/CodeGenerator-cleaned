#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed


#usage: ./tophatCodeGenerator.sh testFolderPath mm9 30mer PE
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2


tophatdate=$(date +"%y%m%d")
printf '''
universe=vanilla

environment = "PATH=/bin:/usr/bin:/usr/local/bin:/woldlab/castor/proj/genome/programs/bowtie-0.12.9:/woldlab/castor/proj/genome/programs/tophat-2.0.13.Linux_x86_64"

getenv = true

executable=/usr/bin/python

log=tophat2.$(Process).log
output=tophat2.$(Process).out
error=tophat2.$(Process).err

request_cpus = 4
request_memory = 9000
request_disk = 0

Requirements = (Machine == "pongo.cacr.caltech.edu" || Machine == "myogenin.cacr.caltech.edu" || Machine == "mondom.cacr.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.cacr.caltech.edu")

''' >> tophat$tophatdate.condor


while read path
    do
        if [[ "$4" == "PE" ]]
            then
                printf "arguments=/woldlab/castor/proj/genome/programs/tophat-2.0.13.Linux_x86_64/tophat -p 4 --GTF  /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered.gtf --transcriptome-index  /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered -o "$path"."$2"."$3"mer /woldlab/castor/home/georgi/genomes/mm9/bowtie-indexes/mm9-single-cell-NIST-fixed-spikes "$path"R1allfastq"$3" "$path"R2allfastq"$3" \nqueue\n" >> tophat$tophatdate".condor"
        elif [[ "$4" == "SE" ]]
            then
                printf "arguments=/woldlab/castor/proj/genome/programs/tophat-2.0.13.Linux_x86_64/tophat -p 4 --GTF  /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered.gtf --transcriptome-index  /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered -o "$path"."$2"."$3"mer /woldlab/castor/home/georgi/genomes/mm9/bowtie-indexes/mm9-single-cell-NIST-fixed-spikes "$path"allfastq"$3" \nqueue\n" >> tophat$tophatdate".condor"
        fi
    done <$1

