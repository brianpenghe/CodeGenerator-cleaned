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
            SampleMeta=$(echo $line | cut -d' ' -f$k- | sed -r "s/[/\ #;,&~]/_/g" )
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

            if [[ "$1" == "PE" ]]
                then
                    printf "cat "$path"*R1.fastq > "$path"R1allfastq && " >> testcode
                    printf "cat "$path"*R2.fastq > "$path"R2allfastq && " >> testcode
                    printf "mkdir "$path"FastQCk6R1 && " >> testcode
                    printf "mkdir "$path"FastQCk6R2 && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"R1allfastq -o "$path"FastQCk6R1 -k 6 && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"R2allfastq -o "$path"FastQCk6R2 -k 6 && " >> testcode
                    printf "java -jar /woldlab/castor/proj/programs/Trimmomatic-0.33/trimmomatic-0.33.jar PE -threads 4 -trimlog "$path"trim.log "$path"R1allfastq "$path"R2allfastq "$path"R1allpairedfastq "$path"R1allunpairedfastq "$path"R2allpairedfastq "$path"R2allunpairedfastq ILLUMINACLIP:NexteraAdaptors.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:"$(($3==0?20:$3))" && " >> testcode
                    if [[ "$3" == "0" ]]
                        then
                            printf "mv "$path"R1allpairedfastq "$path"R1allfastq"$3" && " >> testcode
                            printf "mv "$path"R2allpairedfastq "$path"R2allfastq"$3" && " >> testcode
                    else
                        printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"R1allpairedfastq "$3" -stdout > "$path"R1allfastq"$3" && " >> testcode
                        printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"R2allpairedfastq "$3" -stdout > "$path"R2allfastq"$3" && " >> testcode
                    fi    
            elif [[ "$1" == "SE" ]]
                then
                    printf "cat "$path"*.fastq > "$path"allfastq && " >> testcode
                    printf "mkdir "$path"FastQCk6 && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"allfastq -o "$path"FastQCk6 -k 6 && " >> testcode
                    printf "java -jar /woldlab/castor/proj/programs/Trimmomatic-0.33/trimmomatic-0.33.jar SE -threads 4 -trimlog "$path"trim.log "$path"allfastq "$path"alltrimmedfastq ILLUMINACLIP:NexteraAdaptors.fa:2:30:10 MAXINFO:35:0.9 MINLEN:"$(($3==0?20:$3))" && " >> testcode
                    if [[ "$3" == "0" ]]
                        then
                            printf "mv "$path"alltrimmedfastq "$path"allfastq"$3" && " >> testcode
                    else
                        printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"alltrimmedfastq "$3" -stdout > "$path"allfastq"$3" && " >> testcode
                    fi
            fi
            printf "rm "$path"*fastq & \n" >> testcode
        done <testSampleList
