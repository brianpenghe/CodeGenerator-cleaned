#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/RNAseQC.sh testFolderPath mm9 30mers
#this has to be done after Tophat

echo '' >> testcodeRNAseQC
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeRNAseQC
echo "#RNAseQC codes:" >> testcodeRNAseQC
echo "#*****************" >> testcodeRNAseQC


while read line
    do
        printf "condor_run \" java -jar /woldlab/castor/proj/genome/programs/picard-tools-1.54/AddOrReplaceReadGroups.jar I="$line"."$2"."$3"/accepted_hits.bam O="$line"."$2"."$3"/accepted_hits_gr.bam LB=lane6 PL=illumina PU=lane6 SM=lane6\" && " >> testcodeRNAseQC
        printf "condor_run \" java -jar /woldlab/castor/proj/genome/programs/picard-tools-1.54/ReorderSam.jar I="$line"."$2"."$3"/accepted_hits_gr.bam O="$line"."$2"."$3"/accepted_hits_gr_sort.bam R=/woldlab/castor/proj/genome/bowtie-indexes/mm9-single-cell-NIST-fixed-spikes.fa\" && " >> testcodeRNAseQC
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"/accepted_hits_gr_sort.bam \" && " >> testcodeRNAseQC
        printf "condor_run \' java -jar /woldlab/castor/proj/genome/programs/RNA-SeQC/RNA-SeQC_v1.1.8.jar -o "$line"."$2"."$3"/RNAseQC -ttype 2 -r /woldlab/castor/proj/genome/bowtie-indexes/mm9-single-cell-NIST-fixed-spikes.fa -s \""$(echo $line | rev | cut -d/ -f1 | rev)"|"$line"."$2"."$3"/accepted_hits_gr_sort.bam|Tophat."$2"."$3"\" -singleEnd -t /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered_HA2.gtf > "$line"."$2"."$3"/RNAseQC.out 2> "$line"."$2"."$3"/RNAseQC.err' && " >> testcodeRNAseQC
		printf "rm "$line"."$2"."$3"/accepted_hits_gr.bam "$line"."$2"."$3"/accepted_hits_gr_sort.bam & \n " >> testcodeRNAseQC
    done <$1

chmod a+x testcodeRNAseQC



