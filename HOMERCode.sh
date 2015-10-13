#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/eRangeCode.sh testFolderPath mm9 36mer

echo '' >> testcode
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "HOMER prepare reads, Peak calling and convert to bed(no score) codes:" >> testcode
echo "*****************" >> testcode

echo "export PATH=$PATH:/proj/programs/weblogo:/proj/programs/x86_64/blat/:/proj/programs/homer-4.7/bin" >> testcode

while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2"."$3".unique.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3".unique.nochrM.bam "$line"."$2"."$3".unique.nochrM.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/homer-4.7/bin/makeTagDirectory "$line"."$2"."$3"HomerTags "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/programs/homer-4.7/bin/findPeaks "$line"."$2"."$3"HomerTags -localSize 50000 -minDist 50 -size 150 -fragLength 0 -o "$line"."$2"."$3"lS50000mD50s150fL0 2> "$line"."$2"."$3"lS50000mD50s150fL0.err \" && " >> testcode
        printf "grep 000 "$line"."$2"."$3"lS50000mD50s150fL0 | grep chr - | grep -v = | awk '{print \$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t\"\$1\"\\\t225\\\t\"\$5}' - | sort -k 1d,1 -k 2n,2 > "$line"."$2"."$3"lS50000mD50s150fL0.bed & " >> testcode
    done <$1


echo "" >> testcode
printf "#for the following part: move the folder to public_html, then copy paste the following codes to run" >> testcode

echo '' >> testcode
echo "These are bigBed tracks:" >> testcode
echo "******************" >> testcode
printf "current_folder_name=\$(pwd|rev|cut -d '/' -f1|rev)" >> testcode
printf '''
    for file in *.bigBed
        do
        echo "track type=bigBed name="$file" description="$file" maxHeightPixels=60:32:8 visibility=dense color=150,0,150 bigDataUrl=http://woldlab.caltech.edu/~phe/"$current_folder_name"/"$file >> testcode
        done
''' >> testcode




