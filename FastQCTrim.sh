#!/bin/bash
#this script is part of the refolder scripts which trims reads and runs fastQC
#FastQCTrim.sh PE $path 30
if [[ "$1" == "PE" ]]
    then
        printf "cat "$2"*R1.fastq > "$2"R1allfastq && " >> testcode
        printf "cat "$2"*R2.fastq > "$2"R2allfastq && " >> testcode
        printf "mkdir "$2"FastQCk6R1 && " >> testcode
        printf "mkdir "$2"FastQCk6R2 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R1allfastq -o "$2"FastQCk6R1 -k 6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R2allfastq -o "$2"FastQCk6R2 -k 6 && " >> testcode
        printf "java -jar /woldlab/castor/proj/programs/Trimmomatic-0.33/trimmomatic-0.33.jar PE -threads 4 -trimlog "$2"trim.log "$2"R1allfastq "$2"R2allfastq "$2"R1allpairedfastq "$2"R1allunpairedfastq "$2"R2allpairedfastq "$2"R2allunpairedfastq ILLUMINACLIP:NexteraAdaptors.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:"$(($3==0?20:$3))" && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R1allpairedfastq -o "$2"FastQCk6R1 -k 6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R2allpairedfastq -o "$2"FastQCk6R2 -k 6 && " >> testcode
        if [[ "$3" == "0" ]]
            then
                printf "mv "$2"R1allpairedfastq "$2"R1allfastq"$3" && " >> testcode
                printf "mv "$2"R2allpairedfastq "$2"R2allfastq"$3" && " >> testcode
        else
            printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$2"R1allpairedfastq "$3" -stdout > "$2"R1allfastq"$3" && " >> testcode
            printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$2"R2allpairedfastq "$3" -stdout > "$2"R2allfastq"$3" && " >> testcode
        fi    
elif [[ "$1" == "SE" ]]
    then
        printf "cat "$2"*.fastq > "$2"allfastq && " >> testcode
        printf "mkdir "$2"FastQCk6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"allfastq -o "$2"FastQCk6 -k 6 && " >> testcode
        printf "java -jar /woldlab/castor/proj/programs/Trimmomatic-0.33/trimmomatic-0.33.jar SE -threads 4 -trimlog "$2"trim.log "$2"allfastq "$2"alltrimmedfastq ILLUMINACLIP:NexteraAdaptors.fa:2:30:10 MAXINFO:35:0.9 MINLEN:"$(($3==0?20:$3))" && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"alltrimmedfastq -o "$2"FastQCk6 -k 6 && " >> testcode
        if [[ "$3" == "0" ]]
            then
                printf "mv "$2"alltrimmedfastq "$2"allfastq"$3" && " >> testcode
        else
            printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$2"alltrimmedfastq "$3" -stdout > "$2"allfastq"$3" && " >> testcode
        fi
fi
printf "rm "$2"*fastq & \n" >> testcode

