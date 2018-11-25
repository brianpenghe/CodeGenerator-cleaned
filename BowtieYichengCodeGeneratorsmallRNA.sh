#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed
#Two stages: mapping to dm3 first then mapping to vectors
#usage: ./bowtieCodeGenerator.sh testFolderPath dm3 23_29
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodePostBowtie
echo "#!/bin/bash" >> testcodePostBowtie2
echo "#bigWig (Index, SAMstats, idxstats) codes:" >> testcodePostBowtie 
echo "#bigWig (Index, SAMstats, idxstats) codes:" >> testcodePostBowtie2

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

Requirements = (Machine == "pongo.caltech.edu" || Machine == "myogenin.caltech.edu" || Machine == "mondom.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.caltech.edu")

''' >> bowtie$bowtiedate".condor"

printf '''
universe=vanilla

executable=/bin/sh

log=shell2.$(Process).log
output=shell2.$(Process).out
error=shell2.$(Process).err

request_cpus = 8
request_memory = 4000
request_disk = 0

Requirements = (Machine == "pongo.caltech.edu" || Machine == "myogenin.caltech.edu" || Machine == "mondom.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.caltech.edu")

''' >> bowtie$bowtiedate".2.condor"

while read line
    do
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.dup.bam \" && " >> testcodePostBowtie
		printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2"."$3"mer.unique.dup.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2"."$3"mer.unique.dup.nochrM.bam \" && " >> testcodePostBowtie
		printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.dup.nochrM.bam \" && " >> testcodePostBowtie
        if [[ "$4" == "PE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"R1allfastq"$3" -2 "$line"R2allfastq"$3" --un "$line"."$2"."$3"_unmapped.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
               printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools rmdup "$line"."$2"."$3"mer.unique.dup.nochrM.bam "$line"."$2"."$3"mer.unique.nochrM.bam \" && " >> testcodePostBowtie
               printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UASG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"."$2"."$3"_unmapped_1.fastq -2 "$line"."$2"."$3"_unmapped_2.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UASG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.42AB_UASG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
               printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UBIG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"."$2"."$3"_unmapped_1.fastq -2 "$line"."$2"."$3"_unmapped_2.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UBIG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.42AB_UBIG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
               printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UASG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"."$2"."$3"_unmapped_1.fastq -2 "$line"."$2"."$3"_unmapped_2.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UASG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.66A_UASG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
               printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UBIG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"."$2"."$3"_unmapped_1.fastq -2 "$line"."$2"."$3"_unmapped_2.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UBIG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.66A_UBIG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
        elif [[ "$4" == "SE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 --chunkmbs 1024 -v 0 -a -m 1 -t --sam-nh --best --strata -q --sam "$line"allfastq"$3" --un "$line"."$2"."$3"_unmapped.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT  "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
                printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools rmdup -s "$line"."$2"."$3"mer.unique.dup.nochrM.bam "$line"."$2"."$3"mer.unique.nochrM.bam \" && " >> testcodePostBowtie
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UASG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -t --sam-nh --best --strata -q --sam "$line"."$2"."$3"_unmapped.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UASG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.42AB_UASG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UBIG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -t --sam-nh --best --strata -q --sam "$line"."$2"."$3"_unmapped.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UBIG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.42AB_UBIG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UASG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -t --sam-nh --best --strata -q --sam "$line"."$2"."$3"_unmapped.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UASG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.66A_UASG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UBIG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -t --sam-nh --best --strata -q --sam "$line"."$2"."$3"_unmapped.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UBIG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.66A_UBIG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
        fi
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.nochrM.bam \" & \n " >> testcodePostBowtie
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.42AB_UASG.unique.dup.bam \" && " >> testcodePostBowtie2
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.42AB_UBIG.unique.dup.bam \" && " >> testcodePostBowtie2
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.66A_UASG.unique.dup.bam \" && " >> testcodePostBowtie2
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.66A_UBIG.unique.dup.bam \" & \n " >> testcodePostBowtie2
    done <$1

chmod a+x testcodePostBowtie
chmod a+x testcodePostBowtie2
