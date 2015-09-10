#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed


#usage: ./bowtieCodeGenerator.sh testFolderPath mm9 36mer
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
echo "bowtie.condor codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode

bowtiedate=$(date +"%y%m%d")
printf '''
universe=vanilla

executable=/bin/sh

log=shell.$(Process).log
output=shell.$(Process).out
error=shell.$(Process).err

request_cpus = 8
request_memory = 4000
request_disk = 0

Requirements = (Machine == "pongo.cacr.caltech.edu" || Machine == "myogenin.cacr.caltech.edu" || Machine == "mondom.cacr.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.cacr.caltech.edu")

''' >> bowtie$bowtiedate".condor"

while read path
    do
        printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 -v 2 -k 2 -m 1 -t --sam-nh --best --strata -q --sam "$path"allfastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT  "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$path"."$2"."$3".unique \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
    done <$1



echo '' >> testcode
echo "******take a break***********" >> testcode
echo "bowtie-reports codes:" >> testcode
echo "*****************" >> testcode




printf '''
echo "file processed unique suppressed " > bowtie_report
    for file in shell*err
        do
            all_reads=$(grep processed $file | cut -d: -f2)
            unique_reads=$(grep least $file | cut -d: -f2)
            suppressed_reads=$(grep suppressed $file | cut -d: -f2)
            echo $file $all_reads $unique_reads $suppressed_reads>> bowtie_report
        done

''' >> testcode
