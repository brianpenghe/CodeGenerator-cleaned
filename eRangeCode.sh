#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/eRangeCode.sh testFolderPath mm9 36mer

echo '' >> testcodeeRange
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcodeeRange
echo "******take a break***********" >> testcodeeRange
echo "eRange(chrM-Removal, filtermulti, index, SAMstats, makeRds, findall, regiontobed, bedtobigbed) codes:" >> testcodeeRange
echo "*****************" >> testcodeeRange


while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2"."$3".unique.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcodeeRange
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcodeeRange
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3".unique.nochrM.bam "$line"."$2"."$3".unique.nochrM.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcodeeRange
        printf "condor_run \"python /woldlab/castor/home/georgi/code/erange-4.0a/MakeRdsFromBam5.py reads "$line"."$2"."$3".unique.nochrM.bam "$line"."$2"."$3".unique.nochrM.rds --index --cache=20000000\" && " >> testcodeeRange
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line"."$2"."$3".unique.nochrM.3x.2RPM- "$line"."$2"."$3".unique.nochrM.rds "$line"."$2"."$3".unique.nochrM.3x.2RPM.hts -minimum 2 -ratio 3 -listPeak -cache 20000000 -nodirectionality && " >> testcodeeRange
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line"."$2"."$3".unique.nochrM.5x.4RPM- "$line"."$2"."$3".unique.nochrM.rds "$line"."$2"."$3".unique.nochrM.5x.4RPM.hts -minimum 4 -ratio 5 -listPeak -cache 20000000 -nodirectionality && rm "$line"."$2"."$3".unique.nochrM.rds && rm "$line"."$2"."$3".unique.nochrM.rds.log && " >> testcodeeRange
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line"."$2"."$3".unique.nochrM.3x.2RPM.hts "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed -nolabel && " >> testcodeeRange
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line"."$2"."$3".unique.nochrM.5x.4RPM.hts "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed -nolabel && " >> testcodeeRange
        printf "sort -k 1d,1 -k 2n,3 "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed | intersectBed -a - -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3".unique.nochrM.3x.2RPM.clean.bed && mv "$line"."$2"."$3".unique.nochrM.3x.2RPM.clean.bed "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed &&" >> testcodeeRange
        printf "sort -k 1d,1 -k 2n,3 "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed | intersectBed -a - -b ~/genomes/mm9/mm9-blacklist.bed -v | intersectBed -a - -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3".unique.nochrM.5x.4RPM.clean.bed && mv "$line"."$2"."$3".unique.nochrM.5x.4RPM.clean.bed "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed &&" >> testcodeeRange
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.3x.2RPM.clean.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.3x.2RPM.bigBed && " >> testcodeeRange
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.5x.4RPM.clean.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.5x.4RPM.bigBed & \n" >> testcodeeRange
    done <$1





