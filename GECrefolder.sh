#!/bin/bash
#SampleListGenerator.sh input output
echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
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
                    printf "gunzip -c "$OldDataPath"/*.fastq.gz | cat > "$path$k".fastq && " >> testcode
                    k=$k+1
                done
            printf "mkdir "$path"FastQCk6 && " >> testcode
            printf "cat "$path"*.fastq > "$path"allfastq && " >> testcode
            printf "rm "$path"*.fastq && " >> testcode
            printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"allfastq -o "$path"FastQCk6 -k 6 & \n" >> testcode
        done <testSampleList
