#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed


#usage: ./bowtieCodeGenerator.sh testFolderPath mm9 30mer
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2




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
        printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 -v 2 -k 1 -m 3 -t --trim3 "$3" --sam-nh --best --strata -q --sam "$path"allfastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT  "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$path"."$2"."$3"mer.unique \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
    done <$1



echo '' >> testcode
echo "******take a break***********" >> testcode
echo "bowtie-reports codes:" >> testcode
echo "*****************" >> testcode




printf '''
echo "file processed unique failed suppressed " > bowtie_report
    for file in shell*err
        do
            all_reads=$(grep processed $file | cut -d: -f2)
            unique_reads=$(grep least $file | cut -d: -f2)
            failed_reads=$(grep failed $file | cut -d: -f2)
            suppressed_reads=$(grep suppressed $file | cut -d: -f2)
            echo $file $all_reads $unique_reads $failed_reads $suppressed_reads>> bowtie_report
        done

''' >> testcode
