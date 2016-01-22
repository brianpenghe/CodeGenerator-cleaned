#!/bin/bash
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
