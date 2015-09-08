#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed
#delete the testFolderPath file
#it generates three files: bowtieXXXXXX testcode & testFolderPath
#usage: ~/programs/GECCodeGeneratorATAC.sh test mm9

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


echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
while read path
    do
        printf "mkdir "$path"FastQCk6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"843.fastq -o "$path"FastQCk6 -k 6 \n" >> testcode
        for TrimLength in 20 22 24 26 28 {30..40}
            do
                printf " python /woldlab/castor/home/georgi/code/trimfastq.py "$path"/843.fastq "$TrimLength" -stdout > "$path$TrimLength"allfastq & \n" >> testcode
                echo $path$TrimLength >> testfilepath
            done

    done <$1

source /woldlab/castor/home/phe/programs/BowtieCodeGenerator.sh testfilepath $2 "Scan"

