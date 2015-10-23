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
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.3x.2RPM.bigBed && " >> testcodeeRange
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.5x.4RPM.bigBed & \n" >> testcodeeRange
    done <$1


printf "#for the following part: move the folder to public_html, then copy paste the following codes to run" >> testcode

echo '' >> testcode
echo "These are bigBed tracks:" >> testcode
echo "******************" >> testcode
printf "current_folder_name=\$(pwd|rev|cut -d '/' -f1|rev)" >> testcode
printf '''
    for file in *.bigBed
        do
        echo "track type=bigBed name="$file" description="$file" maxHeightPixels=60:32:8 visibility=pack color=150,0,150 bigDataUrl=http://woldlab.caltech.edu/~phe/"$current_folder_name"/"$file >> tracksummary
        done
''' >> testcode




