#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed
#delete the testFolderPath file
#it generates three files: bowtieXXXXXX testcode & testFolderPath
#usage: ~/programs/GECCodeGeneratorATAC.sh test mm9 36

echo '' > testcode
CurrentLo=$(pwd)
if [ "$2" == "mm9" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/mm9.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/mm9"
    chromsizes="/woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes"
elif [ "$2" == "hg19male" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGR+spikes.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGR+spikes"
    chromsizes="/woldlab/castor/home/georgi/genomes/hg19/hg19-male-single-cell-NIST-fixed-spikes.chrom.sizes"
elif [ "$2" == "hg19female" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGS+spikes.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGS+spikes"
    chromsizes="/woldlab/castor/home/georgi/genomes/hg19/hg19-female-single-cell-NIST-fixed-spikes.chrom.sizes"
fi

source /woldlab/castor/home/phe/programs/DownloadFolder.sh $1

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
while read line
    do
        Folders=$(echo $line | cut -d' ' -f1 | sed "s/https:\///g" | rev | cut -d '/' -f3- | rev)
        SampleID=$(echo $line | cut -d' ' -f1 | rev | cut -d '/' -f2 | rev)
        SampleMeta=$(echo $line | cut -d' ' -f2- | sed "s/\//_/g" | sed "s/ /_/g")
        OldDataPath=$(echo $CurrentLo$Folders"/"$SampleID)
        path=$(echo $CurrentLo"/"$SampleID$SampleMeta)
        printf "mv "$OldDataPath" "$path" && " >> testcode
        printf $path"\n" >> testFolderPath
        printf "mkdir "$path"FastQCk6 && " >> testcode
        printf "gunzip -c "$path"/*.fastq.gz | python /woldlab/castor/home/georgi/code/trimfastq.py - "$3" -stdout > "$path"allfastq && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"allfastq -o "$path"FastQCk6 -k 6 & \n" >> testcode
    done <$1

source /woldlab/castor/home/phe/programs/BowtieCodeGenerator.sh testFolderPath $2 $3"mer"

source /woldlab/castor/home/phe/programs/eRangeCode.sh testFolderPath $2 $3"mer"

source /woldlab/castor/home/phe/programs/bigWigCode.sh testFolderPath $2 $3"mer"



