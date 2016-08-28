#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed


#usage: ./bowtieCodeGenerator.sh testFolderPath mm9 30mer
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2
echo '' >> testcodePostBowtie
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

Requirements = (Machine == "pongo.cacr.caltech.edu" || Machine == "myogenin.cacr.caltech.edu" || Machine == "mondom.cacr.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.cacr.caltech.edu")

''' >> bowtie$bowtiedate".condor"

while read path
    do
        if [[ "$4" == "PE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 -v 2 -k 1 -m 3 -X 2000 -t --sam-nh --best -y --strata -q --sam -1 "$path"R1allfastq"$3" -2 "$path"R2allfastq"$3" | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$path"."$2"."$3"mer.unique \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
        elif [[ "$4" == "SE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 -v 2 -k 1 -m 3 -t --sam-nh --best -y --strata -q --sam "$path"allfastq"$3" | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT  "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$path"."$2"."$3"mer.unique \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
        fi
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.bam \" && " >> testcodePostBowtie
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3".unique.bam "$line"."$2"."$3".SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcodePostBowtie
        printf "condor_run \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2"."$3".unique.bam > "$line"."$2"."$3".idxstats\" && " >> testcodePostBowtie
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2"."$3".unique.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcodePostBowtie
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcodePostBowtie
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3".unique.nochrM.bam "$line"."$2"."$3".unique.nochrM.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" & " >> testcodePostBowtie       
    done <$1

chmod a+x testcodePostBowtie