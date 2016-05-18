#!/bin/bash
echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
if [[ "$4" != "SE" && "$4" != "PE" ]]
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
        if [[ "$4" == "PE" ]]
            then
                printf "mkdir "$path"FastQCk6R1 && " >> testcode
                printf "mkdir "$path"FastQCk6R2 && " >> testcode
                printf "cat "$path"/*_R1_*.fastq > "$path"R1allfastq && " >> testcode
                printf "cat "$path"/*_R2_*.fastq > "$path"R2allfastq && " >> testcode
                printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"R1allfastq -o "$path"FastQCk6R1 -k 6 && " >> testcode
                printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"R2allfastq -o "$path"FastQCk6R2 -k 6 && " >> testcode
				printf ""$path"R1allfastq\n" >> $path"FastUniqInput"
				printf ""$path"R2allfastq\n" >> $path"FastUniqInput"
				printf "~/programs/FastUniq/source/fastuniq -i "$path"FastUniqInput -t q -o "$path"R1allfastquniq -p "$path"R2allfastquniq && rm "$path"FastUniqInput && " >> testcode
                printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"R1allfastquniq "$3" -stdout > "$path"R1allfastq"$3" && rm "$path"R1allfastquniq && " >> testcode
                printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"R2allfastquniq "$(echo $3 - 10 | bc)" -trim5 10 -stdout > "$path"R2allfastq"$3" && rm "$path"R2allfastquniq && " >> testcode
        elif [[ "$4" == "SE" ]]
            then
                printf "mkdir "$path"FastQCk6 && " >> testcode
                printf "cat "$path"/*.fastq > "$path"allfastq && " >> testcode
                printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"allfastq -o "$path"FastQCk6 -k 6 && " >> testcode
                printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$path"allfastq "$(echo $3 - 10 | bc)" -trim5 10 -stdout > "$path"allfastq"$3" && " >> testcode
        fi
        printf "rm "$path"*fastq & \n" >> testcode
    done <$1
