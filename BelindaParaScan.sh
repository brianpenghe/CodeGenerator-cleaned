#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed
#delete the testFolderPath file
#it generates three files: bowtieXXXXXX testcode & testFolderPath
#usage: ~/programs/GECCodeGeneratorATAC.sh test mm9

echo '' > testcode
CurrentLo=$(pwd)
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
while read path
    do
        printf "mkdir "$path"FastQCk6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"843.fastq -o "$path"FastQCk6 -k 6 \n" >> testcode
        for TrimLength in 20 22 24 26 28 {30..40}
            do
                printf " python /woldlab/castor/home/georgi/code/trimfastq.py "$path"/843.fastq "$TrimLength" -stdout > "$path$TrimLength"allfastq & \n" >> testcode
                echo $path$TrimLength >> testfilepath
            done

    done <$1

source /woldlab/castor/home/phe/programs/BowtieCodeGenerator.sh testfilepath $2 "Scan"

