#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/eRangeCode.sh testFolderPath mm9 36mer

echo '' >> testcode
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "eRange(chrM-Removal, filtermulti, index, SAMstats, makeRds, findall, regiontobed, bedtobigbed) codes:" >> testcode
echo "*****************" >> testcode


while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2"."$3".unique.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" python /woldlab/castor/home/georgi/code/filterBAMMulti.py "$line"."$2"."$3".unique.nochrM.bam /woldlab/castor/proj/programs/samtools-0.1.8/samtools 1 "$line"."$2"."$3".unique.nochrM.aligned.bam\" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.nochrM.aligned.bam \" && rm "$line"."$2"."$3".unique.nochrM.bam && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3".unique.nochrM.aligned.bam "$line"."$2"."$3".unique.nochrM.aligned.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/erange-4.0a/MakeRdsFromBam5.py reads "$line"."$2"."$3".unique.nochrM.aligned.bam "$line"."$2"."$3".unique.nochrM.aligned.rds --index --cache=20000000\" && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line"."$2"."$3".unique.nochrM.3x.2RPM- "$line"."$2"."$3".unique.nochrM.aligned.rds "$line"."$2"."$3".unique.nochrM.3x.2RPM.hts -minimum 2 -ratio 3 -listPeak -cache 20000000 -nodirectionality && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line"."$2"."$3".unique.nochrM.5x.4RPM- "$line"."$2"."$3".unique.nochrM.aligned.rds "$line"."$2"."$3".unique.nochrM.5x.4RPM.hts -minimum 4 -ratio 5 -listPeak -cache 20000000 -nodirectionality && rm "$line"."$2"."$3".unique.nochrM.aligned.rds && rm "$line"."$2"."$3".unique.nochrM.aligned.rds.log && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line"."$2"."$3".unique.nochrM.3x.2RPM.hts "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed -nolabel && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line"."$2"."$3".unique.nochrM.5x.4RPM.hts "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed -nolabel && " >> testcode
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.3x.2RPM.bigBed && " >> testcode
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.5x.4RPM.bigBed & \n" >> testcode
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




