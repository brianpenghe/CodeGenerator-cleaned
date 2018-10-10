#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed

#usage: ./bowtieCodeGenerator.sh testFolderPath mm9 30mer
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2
echo '' > testcodePostBowtie
echo "#!/bin/bash" >> testcodePostBowtie
echo "#bigWig (Index, SAMstats, idxstats) codes:" >> testcodePostBowtie 

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

while read line
    do
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.dup.bam \" && " >> testcodePostBowtie
        printf "condor_run -a request_memory=20000 \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3"mer.unique.dup.bam "$line"."$2"."$3"mer.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcodePostBowtie
        printf "condor_run -a request_memory=20000 \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2"."$3"mer.unique.dup.bam > "$line"."$2"."$3"mer.dup.idxstats\" && " >> testcodePostBowtie
		printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2"."$3"mer.unique.dup.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2"."$3"mer.unique.dup.nochrM.bam \" && " >> testcodePostBowtie
		printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.dup.nochrM.bam \" && " >> testcodePostBowtie
        printf "condor_run -a request_memory=20000 \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3"mer.unique.dup.nochrM.bam "$line"."$2"."$3"mer.unique.nochrM.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcodePostBowtie
        if [[ "$4" == "PE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 --chunkmbs 1024 -v 2 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"R1allfastq"$3" -2 "$line"R2allfastq"$3" | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
                printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools rmdup "$line"."$2"."$3"mer.unique.dup.nochrM.bam "$line"."$2"."$3"mer.unique.nochrM.bam \" && " >> testcodePostBowtie
        elif [[ "$4" == "SE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 --chunkmbs 1024 -v 2 -a -m 1 -t --sam-nh --best -y --strata -q --sam "$line"allfastq"$3" | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT  "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
                printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools rmdup -s "$line"."$2"."$3"mer.unique.dup.nochrM.bam "$line"."$2"."$3"mer.unique.nochrM.bam \" && " >> testcodePostBowtie
        fi
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.nochrM.bam \" && " >> testcodePostBowtie
        printf "condor_run -a request_memory=20000 \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2"."$3"mer.unique.nochrM.bam > "$line"."$2"."$3"mer.idxstats\" & \n " >> testcodePostBowtie
    done <$1

chmod a+x testcodePostBowtie