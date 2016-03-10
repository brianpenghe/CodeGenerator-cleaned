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
            SampleID=$(echo $line | cut -d' ' -f1 | rev | cut -d '/' -f4 | rev)
			#Now scan through the whole line
            while [[ $(echo $line | cut -d' ' -f$k | cut -c1-3) == "ftp" ]]
                do
                    Folder[$k]=$(echo $line | cut -d' ' -f$k | rev | cut -d '/' -f1 | rev)
                    k=$k+1
                done
            SampleMeta=$(echo $line | cut -d' ' -f$k- | sed -r "s/[/\ #;&~]/_/g" )
            path=$(echo $CurrentLo"/"$SampleID$SampleMeta)
            printf $path"\n" >> testFolderPath
            k=1
			
			#now manipulate the files and do a second scan
            while [[ $(echo $line | cut -d' ' -f$k | cut -c1-3) == "ftp" ]]
                do
                    if [[ "$1" == "PE" ]]
                        then
                            printf "woldlab/castor/home/georgi/programs/sratoolkit.2.3.1-ubuntu64/bin/fastq-dump.2.3.1 -Z "${Folder[$k]}" --split-3 && " >> testcode
							printf "mv "$(echo ${Folder[$k]} | sed "s/.sra//g")"_1.fastq "$path$k".R1.fastq && " >> testcode
							printf "mv "$(echo ${Folder[$k]} | sed "s/.sra//g")"_2.fastq "$path$k".R1.fastq && " >> testcode
                            
                    elif [[ "$1" == "SE" ]]
                        then
							printf "/woldlab/castor/home/georgi/programs/sratoolkit.2.3.1-ubuntu64/bin/fastq-dump.2.3.1 -Z "${Folder[$k]}" > "$path$k".fastq && " >> testcode
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
                    printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"R1allfastq "$3" -stdout > "$path"R1allfastq"$3" && " >> testcode
                    printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"R2allfastq "$3" -stdout > "$path"R2allfastq"$3" && " >> testcode
            elif [[ "$1" == "SE" ]]
                then
                    printf "cat "$path"*.fastq > "$path"allfastq && " >> testcode
                    printf "mkdir "$path"FastQCk6 && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"allfastq -o "$path"FastQCk6 -k 6 && " >> testcode
                    printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"allfastq "$3" -stdout > "$path"allfastq"$3" && " >> testcode
            fi
            printf "rm "$path"*fastq & \n" >> testcode
        done <testSampleList
