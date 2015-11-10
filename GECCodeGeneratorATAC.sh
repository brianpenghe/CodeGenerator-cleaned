#!/bin/bash
#Run these codes in the current SERVER directory
#it generates three testfiles: testcode, testFolderPath and testSampleList
#usage: ~/programs/GECCodeGeneratorATAC.sh test mm9 36
#test file is just a list of library ID(number)s.
#this script enables combining multiple flowcells.

echo '' > testcode
CurrentLo=$(pwd)
/woldlab/castor/home/phe/programs/SampleListGenerator.sh $1 testSampleList
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2
/woldlab/castor/home/phe/programs/DownloadFolder.sh testSampleList

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
        SampleMeta=$(echo $line | cut -d' ' -f$k- | sed -r "s/[\ #;&~]/_/g" )
        path=$(echo $CurrentLo"/"$SampleID$SampleMeta)
        printf $path"\n" >> testFolderPath
        printf "mkdir "$path" && " >> testcode
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

/woldlab/castor/home/phe/programs/BowtieCodeGenerator.sh testFolderPath $2 $3

/woldlab/castor/home/phe/programs/eRangeCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/HOMERCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/bigWigCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/FseqCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TrackSummary.sh bigBed

/woldlab/castor/home/phe/programs/Stats.sh testFolderPath $2 $3


