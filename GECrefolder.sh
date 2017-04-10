#!/bin/bash
#GECrefolder.sh PE mm9 30
#Thie script also needs a file named testSampleList
#this file contains links to the data to aggregate and its metadata
#e.g each line can be http://jumpgate.caltech.edu/runfolders/volvox/141121_SN787_0295_BHBE3UADXX/Unaligned/Project_15160_indexN707-N505/Sample_15160/ http://jumpgate.caltech.edu/runfolders/volvox/141110_SN787_0290_AHCCNNADXX/Unaligned/Project_15160_indexN707-N505/Sample_15160/  Sample15160
#separated by space
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
            declare -i k
            k=1
            declare -a Folder
            SampleID=$(echo $line | cut -d' ' -f1 | rev | cut -d '/' -f2 | rev)
            while [[ $(echo $line | cut -d' ' -f$k | cut -c1-4) == "http" ]]
                do
                    Folder[$k]=$(echo $line | cut -d' ' -f$k | sed "s/https:\///g" | rev | cut -d '/' -f3- | rev)
                    k=$k+1
                done
            SampleMeta=$(echo $line | cut -d' ' -f$k-)
            path=$(echo $CurrentLo"/"$SampleID$SampleMeta)
            printf $path"\n" >> testFolderPath
            k=1
            while [[ $(echo $line | cut -d' ' -f$k | cut -c1-4) == "http" ]]
                do
                    OldDataPath=$(echo $CurrentLo${Folder[$k]}"/"$SampleID)
                    if [[ "$1" == "PE" ]]
                        then
                            printf "gunzip -c "$OldDataPath"/*_R1_*.fastq.gz | cat > "$path$k".R1.fastq && " >> testcode
                            printf "gunzip -c "$OldDataPath"/*_R2_*.fastq.gz | cat > "$path$k".R2.fastq && " >> testcode
                    elif [[ "$1" == "SE" ]]
                        then
                            printf "gunzip -c "$OldDataPath"/*.fastq.gz | cat > "$path$k".fastq && " >> testcode
                    fi
                    k=$k+1
                done
            ~/programs/FastQCTrim.sh $1 $path $3
        done <testSampleList
