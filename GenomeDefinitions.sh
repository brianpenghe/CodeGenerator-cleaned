#!/bin/bash
#Run these codes in the current SERVER directory

#usage: ./GenomeDefinitions.sh mm9
CurrentLo=$(pwd)
if [ "$1" == "mm9full" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/mm9.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/mm9"
    chromsizes="/woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/mm9/mm9-blacklist.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/mm9/chrM30mermm9lS50000mD50s150fL0.bed"

elif [ "$1" == "mm9" ]
then
    fa="/woldlab/castor/home/phe/genomes/mm9/male.mm9.fa"
    bowtieindex="/woldlab/castor/home/phe/genomes/mm9/male.mm9"
    chromsizes="/woldlab/castor/home/phe/genomes/mm9/male.mm9.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/mm9/mm9-blacklist.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/mm9/chrM30mermm9lS50000mD50s150fL0.bed"

elif [ "$1" == "mm10full" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/mm10.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/mm10"
    chromsizes="/woldlab/castor/home/georgi/genomes/mm10/mm10.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/mm10/mm10blacklist_Ricardo.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/mm10/chrM30mermm10lS50000mD50s150fL0.bed"

elif [ "$1" == "mm10" ]
then
fa="/woldlab/castor/home/phe/genomes/mm10/male.mm10.chrom.fa"
bowtieindex="/woldlab/castor/home/phe/genomes/mm10/male.mm10.chrom"
chromsizes="/woldlab/castor/home/phe/genomes/mm10/male.mm10.chrom.sizes"
blacklist="/woldlab/castor/home/phe/genomes/mm10/mm10blacklist_Ricardo.bed"
mitoblack="/woldlab/castor/home/phe/genomes/mm10/chrM30mermm10lS50000mD50s150fL0.bed"

elif [ "$1" == "hg19male" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGR+spikes.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGR+spikes"
    chromsizes="/woldlab/castor/home/georgi/genomes/hg19/hg19-male-single-cell-NIST-fixed-spikes.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/hg19/blacklist/wgEncodeDacMapabilityConsensusExcludable.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/hg19/blacklist/blacklist_.hg19male.30merlS50000mD50s150fL0.bed"
elif [ "$1" == "hg19female" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGS+spikes.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGS+spikes"
    chromsizes="/woldlab/castor/home/georgi/genomes/hg19/hg19-female-single-cell-NIST-fixed-spikes.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/hg19/blacklist/wgEncodeDacMapabilityConsensusExcludable.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/hg19/blacklist/blacklist_.hg19male.30merlS50000mD50s150fL0.bed"
elif [ "$1" == "hg38full" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/hg38.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/hg38"
    chromsizes="/woldlab/castor/home/phe/genomes/hg38/hg38.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/hg38/hg19blacklist_liftedovertohg38.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/hg38/chrM30merschrM30mers.hg38.30merlS50000mD50s150fL0.bed"
elif [ "$1" == "hg38" ]
then
fa="/woldlab/castor/home/phe/genomes/hg38/hg38male.fa"
bowtieindex="/woldlab/castor/home/phe/genomes/hg38/hg38male"
chromsizes="/woldlab/castor/home/phe/genomes/hg38/hg38male.chrom.sizes"
blacklist="/woldlab/castor/home/phe/genomes/hg38/hg19blacklist_liftedovertohg38.bed"
mitoblack="/woldlab/castor/home/phe/genomes/hg38/chrM30merschrM30mers.hg38.30merlS50000mD50s150fL0.bed"
fi


