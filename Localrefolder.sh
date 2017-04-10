#!/bin/bash
echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
if [[ "$4" != "SE" && "$4" != "PE" ]]
    then
		echo $4
        printf "single end(SE) or paired end(PE)?"
        exit 1 
fi
while read line
    do
        Folders=$(echo $line | cut -d' ' -f1)
        SampleMeta=$(echo $line | cut -d' ' -f2-)
        path=$(echo $CurrentLo"/"$Folders$SampleMeta)
		if [[ "$4" == "PE" ]]
			then
				printf "cat "$Folders"/*R1.fastq > "$path"R1.fastq && " >> testcode
				printf "cat "$Folders"/*R2.fastq > "$path"R2.fastq && " >> testcode
		elif [[ "$4" == "SE" ]]
			then
				printf "cat "$Folders"/*.fastq > "$path".fastq && " >> testcode
		fi
        printf $path"\n" >> testFolderPath
        ~/programs/FastQCTrim.sh $4 $path $3
    done <$1
