#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/RNAseQC.sh testFolderPath mm9
#this has to be done after Tophat

echo '' >> testcodeRNAseQC
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcodeRNAseQC
echo "******take a break***********" >> testcodeRNAseQC
echo "RNAseQC codes:" >> testcodeRNAseQC
echo "*****************" >> testcodeRNAseQC


while read line
    do
        printf "condor_run \" java -jar /woldlab/castor/proj/genome/programs/picard-tools-1.54/AddOrReplaceReadGroups.jar I="$line"."$2"."$3"/accepted_hits.bam O="$line"."$2"."$3"/accepted_hits_gr.bam LB=lane6 PL=illumina PU=lane6 SM=lane6\" && " >> testcodeRNAseQC
        printf "condor_run \" java -jar /woldlab/castor/proj/genome/programs/picard-tools-1.54/AddOrReplaceReadGroups.jar I="$line"."$2"."$3"/accepted_hits_gr.bam O="$line"."$2"."$3"/accepted_hits_gr_sort.bam R=/woldlab/castor/proj/genome/bowtie-indexes/mm9-single-cell-NIST-fixed-spikes.fa\" && " >> testcodeRNAseQC
        printf ""
    done <$1





