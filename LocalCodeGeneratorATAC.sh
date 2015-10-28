#!/bin/bash
#Run these codes in the current SERVER directory
#the files must be fastq files, no compressed forms allowed
#the file $test has two columns, Full Location Path and name, only one space allowed
#each experiment folder contains a set of fastq files belonging to the same library
# for example: /woldlab/castor/home/phe/ChIPseq   test1
#delete the testFolderPath file
#it generates three files: bowtieXXXXXX testcode & testFolderPath
#usage: ~/programs/GECCodeGeneratorATAC.sh test mm9 36

echo '' > testcode
CurrentLo=$(pwd)
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
while read line
    do
        Folders=$(echo $line | cut -d' ' -f1 | rev | cut -d '/' -f2- | rev)
        SampleID=$(echo $line | cut -d' ' -f1 | rev | cut -d '/' -f1 | rev)
        SampleMeta=$(echo $line | cut -d' ' -f2- | sed "s/\//_/g" | sed "s/ /_/g" | sed "s/#/_/g")
        OldDataPath=$(echo $Folders"/"$SampleID)
        path=$(echo $CurrentLo"/"$SampleID$SampleMeta)
        printf "mv "$OldDataPath" "$path" && " >> testcode
        printf $path"\n" >> testFolderPath
        printf "mkdir "$path"FastQCk6 && " >> testcode
        printf "cat "$path"/*.fastq > "$path"allfastq && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"allfastq -o "$path"FastQCk6 -k 6 & \n" >> testcode
    done <$1

/woldlab/castor/home/phe/programs/BowtieCodeGenerator.sh testFolderPath $2 $3

/woldlab/castor/home/phe/programs/eRangeCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/HOMERCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/bigWigCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/FseqCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TrackSummary.sh bigBed

/woldlab/castor/home/phe/programs/Stats.sh testFolderPath $2 $3


