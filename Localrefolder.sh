#!/bin/bash
echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
if [[ "$1" != "SE" && "$1" != "PE" ]]
    then
        printf "single end(SE) or paired end(PE)?"
        exit 1 
fi
while read line
    do
        Folders=$(echo $line | cut -d' ' -f1 | rev | cut -d '/' -f2- | rev)
        SampleID=$(echo $line | cut -d' ' -f1 | rev | cut -d '/' -f1 | rev)
        SampleMeta=$(echo $line | cut -d' ' -f2- | sed "s/\//_/g" | sed "s/ /_/g" | sed "s/#/_/g")
        OldDataPath=$(echo $Folders"/"$SampleID)
        path=$(echo $CurrentLo"/"$SampleID$SampleMeta)
        printf "mv "$OldDataPath" "$path" && " >> testcode
        printf $path"\n" >> testFolderPath
        ~/programs/FastQCTrim.sh $1 $path $3
    done <$1
