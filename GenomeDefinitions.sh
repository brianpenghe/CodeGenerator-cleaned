#!/bin/bash
#Run these codes in the current SERVER directory

#usage: ./GenomeDefinitions.sh mm9
CurrentLo=$(pwd)
if [ "$1" == "galGal4full" ]
then
    fa="/woldlab/castor/home/phe/genomes/galGal4/galGal4.fa"
    bowtieindex="/woldlab/castor/home/phe/genomes/galGal4/galGal4"
    chromsizes="/woldlab/castor/home/phe/genomes/galGal4/galGal4.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/galGal4/galGal4.chrM30merslS50000mD50s150fL0.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/galGal4/galGal4.chrM30merslS50000mD50s150fL0.bed"

elif [ "$1" == "galGal4" ]
then
    fa="/woldlab/castor/home/phe/genomes/galGal4/galGal4.clean.fa"
    bowtieindex="/woldlab/castor/home/phe/genomes/galGal4/galGal4.clean"
    chromsizes="/woldlab/castor/home/phe/genomes/galGal4/galGal4.clean.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/galGal4/galGal4.chrM30merslS50000mD50s150fL0.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/galGal4/galGal4.chrM30merslS50000mD50s150fL0.bed"	

elif [ "$1" == "MG1655" ]
then
	fa="/woldlab/castor/home/phe/genomes/K-12MG1655/K-12MG1655.fa"
	bowtieindex="/woldlab/castor/home/phe/genomes/K-12MG1655/bowtie1-index/K-12MG1655"
	chromsizes="/woldlab/castor/home/phe/genomes/K-12MG1655/bowtie1-index/K-12MG1655.chrom.sizes"
	
elif [ "$1" == "MC4100" ]	
then
	fa="/woldlab/castor/home/phe/genomes/K-12MC4100/K-12MC4100.fa"
	bowtieindex="/woldlab/castor/home/phe/genomes/K-12MC4100/bowtie1-index/K-12MC4100"
	chromsizes="/woldlab/castor/home/phe/genomes/K-12MC4100/bowtie1-index/K-12MC4100.chrom.sizes"
	
elif [ "$1" == "Spur4.2" ]
then
    fa="/woldlab/castor/home/phe/genomes/Spur4.2/Spur4.2_scaffolds.fa"
    bowtieindex="/woldlab/castor/home/phe/genomes/Spur4.2/Spur4.2_scaffolds"
    chromsizes="/woldlab/castor/home/phe/genomes/Spur4.2/Spur4.2_scaffolds.chrom.sizes"
    blacklist=""
    mitoblack=""
	
elif [ "$1" == "strPur2" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/strPur2.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/strPur2"
    chromsizes="/woldlab/castor/proj/genome/bowtie-indexes/strPur2.chrom.sizes"
	
elif [ "$1" == "Spur3.1" ]
then
    fa="/woldlab/castor/home/phe/genomes/Spur3.1/Spur_v3.1_assembly/LinearScaffolds/Spur_3.1.LinearScaffold.fa"
    bowtieindex="/woldlab/castor/home/phe/genomes/Spur3.1/Spur_v3.1_assembly/LinearScaffolds/Spur_3.1.LinearScaffold"
    chromsizes="/woldlab/castor/home/phe/genomes/Spur3.1/Spur_v3.1_assembly/LinearScaffolds/Spur_3.1.LinearScaffold.chrom.sizes"

elif [ "$1" == "mm9full" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/mm9.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/mm9"
    chromsizes="/woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/mm9/mm9-blacklist.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/mm9/male.mm9.chrM30merslS50000mD50s150fL0.bed"

elif [ "$1" == "mm9" ]
then
    fa="/woldlab/castor/home/phe/genomes/mm9/male.mm9.fa"
    bowtieindex="/woldlab/castor/home/phe/genomes/mm9/male.mm9"
    chromsizes="/woldlab/castor/home/phe/genomes/mm9/male.mm9.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/mm9/mm9-blacklist.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/mm9/male.mm9.chrM30merslS50000mD50s150fL0.bed"
	GTF="/woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered.gtf"

elif [ "$1" == "mm10full" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/mm10.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/mm10"
    chromsizes="/woldlab/castor/home/georgi/genomes/mm10/mm10.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/mm10/mm10blacklist_Ricardo.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/mm10/male.mm10.chrom.chrM30merslS50000mD50s150fL0.bed"

elif [ "$1" == "mm10" ]
then
    fa="/woldlab/castor/home/phe/genomes/mm10/male.mm10.chrom.fa"
    bowtieindex="/woldlab/castor/home/phe/genomes/mm10/male.mm10.chrom"
    chromsizes="/woldlab/castor/home/phe/genomes/mm10/male.mm10.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/mm10/mm10blacklist_Ricardo.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/mm10/male.mm10.chrom.chrM30merslS50000mD50s150fL0.bed"

elif [ "$1" == "hg19male" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGR+spikes.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGR+spikes"
    chromsizes="/woldlab/castor/home/georgi/genomes/hg19/hg19-male-single-cell-NIST-fixed-spikes.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/hg19/blacklist/wgEncodeDacMapabilityConsensusExcludable.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/hg19/blacklist/ENCFF001RGR+spikes.chrM30merslS50000mD50s150fL0.bed"
elif [ "$1" == "hg19female" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGS+spikes.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGS+spikes"
    chromsizes="/woldlab/castor/home/georgi/genomes/hg19/hg19-female-single-cell-NIST-fixed-spikes.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/hg19/blacklist/wgEncodeDacMapabilityConsensusExcludable.bed"
    mitoblack="/woldlab/castor/home/phe/genomes/hg19/blacklist/ENCFF001RGR+spikes.chrM30merslS50000mD50s150fL0.bed"
elif [ "$1" == "hg38full" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/hg38.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/hg38"
    chromsizes="/woldlab/castor/home/phe/genomes/hg38/hg38.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/hg38/hg19blacklist_liftedovertohg38.bed"
    mitoblack="hg38male.chrM30merslS50000mD50s150fL0.bed"
elif [ "$1" == "hg38" ]
then
    fa="/woldlab/castor/home/phe/genomes/hg38/hg38male.fa"
    bowtieindex="/woldlab/castor/home/phe/genomes/hg38/hg38male"
    chromsizes="/woldlab/castor/home/phe/genomes/hg38/hg38male.chrom.sizes"
    blacklist="/woldlab/castor/home/phe/genomes/hg38/hg19blacklist_liftedovertohg38.bed"
    mitoblack="hg38male.chrM30merslS50000mD50s150fL0.bed"

else
    printf "Genome Version not found"
    exit 1
fi


