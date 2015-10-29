#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/eRangeCode.sh testFolderPath mm9 36mer

echo '' >> testcodeHOMER
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcodeHOMER
echo "******take a break***********" >> testcodeHOMER
echo "HOMER prepare reads, Peak calling and convert to bed(no score) codes:" >> testcodeHOMER
echo "*****************" >> testcodeHOMER

echo "export PATH=$PATH:/proj/programs/weblogo:/proj/programs/x86_64/blat/:/proj/programs/homer-4.7/bin" >> testcodeHOMER

while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2"."$3".unique.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcodeHOMER
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcodeHOMER
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3".unique.nochrM.bam "$line"."$2"."$3".unique.nochrM.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcodeHOMER
        printf "condor_run \" /woldlab/castor/proj/programs/homer-4.7/bin/makeTagDirectory "$line"."$2"."$3"HomerTags "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcodeHOMER
        printf "condor_run \"/woldlab/castor/proj/programs/homer-4.7/bin/findPeaks "$line"."$2"."$3"HomerTags -localSize 50000 -minDist 50 -size 150 -fragLength 0 -o "$line"."$2"."$3"lS50000mD50s150fL0 2> "$line"."$2"."$3"lS50000mD50s150fL0.err \" && " >> testcodeHOMER
        printf "grep 000 "$line"."$2"."$3"lS50000mD50s150fL0 | grep chr - | grep -v = | awk '{print \$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t\"\$1\"\\\t225\\\t\"\$5}' - | sort -k 1d,1 -k 2n,2 | intersectBed -a - -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3"lS50000mD50s150fL0.bed && " >> testcodeHOMER
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0.bigBed & \n" >> testcodeHOMER
    done <$1







