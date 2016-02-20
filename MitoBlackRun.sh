#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/MitoBlackRun mm9

CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $1
echo "chrM" > test
python ~/programs/fastaSubset.py test 0 $fa $bowtieindex.chrM.fa
python ~/programs/genome-to-kmer-fasta.py $bowtieindex.chrM.fa $bowtieindex.chrM30mers 30 1000000

 /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie $bowtieindex -p 8 -v 2 -k 1 -m 3 -t --sam-nh --best -y --strata -f --sam $bowtieindex.chrM30mers | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT $fa -  | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - $bowtieindex.chrM30mers

export PATH=$PATH:/proj/programs/weblogo:/proj/programs/x86_64/blat/:/proj/programs/homer-4.7/bin

condor_run "/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view $bowtieindex.chrM30mers.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT $fa - -o $bowtieindex.chrM30mers.nochrM.bam " && condor_run " /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index $bowtieindex.chrM30mers.nochrM.bam" && condor_run " /woldlab/castor/proj/programs/homer-4.7/bin/makeTagDirectory $bowtieindex.chrM30mersHOMERTags $bowtieindex.chrM30mers.nochrM.bam" && condor_run "/woldlab/castor/proj/programs/homer-4.7/bin/findPeaks $bowtieindex.chrM30mersHOMERTags -localSize 50000 -minDist 50 -size 150 -fragLength 0 -o $bowtieindex.chrM30merslS50000mD50s150fL0 2> $bowtieindex.chrM30merslS50000mD50s150fL0.err" && grep 000 $bowtieindex.chrM30merslS50000mD50s150fL0 | grep chr - | grep -v = | awk '{print $2"\t"$3"\t"$4"\t"$1"\t225\t"$5}' - | sort -k 1d,1 -k 2n,2 > $bowtieindex.chrM30merslS50000mD50s150fL0.bed

rm test