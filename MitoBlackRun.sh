#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/MitoBlackRun mm9

CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $1
echo "chrM" > test
python ~/programs/fastaSubset.py test 0 $fa $bowtieindex.chrM.fa
python ~/programs/genome-to-kmer-fasta.py $bowtieindex.chrM.fa $bowtieindex.chrM30mers 30 1000000

 /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie $bowtieindex -p 8 -v 2 -k 1 -m 3 -t --sam-nh --best -y --strata -f --sam $bowtieindex.chrM30mers | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT $fa -  | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - $bowtieindex.chrM30mers &&
/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view $bowtieindex.chrM30mers.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT $fa - -o $bowtieindex.chrM30mers.nochrM.bam bedtools bamtobed -i - | sort -k 1d,1 -k 2n,3 | bedtools merge -i - > $bowtieindex.chrM30merslS50000mD50s150fL0.bed

rm test