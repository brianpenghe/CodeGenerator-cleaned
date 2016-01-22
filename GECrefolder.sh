#!/bin/bash
#GECrefolder.sh PE
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
            SampleMeta=$(echo $line | cut -d' ' -f$k- | sed -r "s/[/\ #;&~]/_/g" )
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
            printf "mkdir "$path"FastQCk6 && " >> testcode
            if [[ "$1" == "PE" ]]
                then
                    printf "cat "$path"*R1.fastq > "$path"R1allfastq && " >> testcode
                    printf "cat "$path"*R2.fastq > "$path"R2allfastq && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"R1allfastq -o "$path"FastQCk6R1 -k 6 & \n" >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"R2allfastq -o "$path"FastQCk6R2 -k 6 & \n" >> testcode
            elif [[ "$1" == "SE" ]]
                then
                    printf "cat "$path"*.fastq > "$path"allfastq && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"allfastq -o "$path"FastQCk6 -k 6 & \n" >> testcode
            fi
            printf "rm "$path"*.fastq && " >> testcode
        done <testSampleList
