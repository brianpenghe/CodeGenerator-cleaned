#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed

#usage: ./STARCodeGeneratorYicheng.sh testFolderPath mm9 30 PE
#This version is specially designed for Yicheng's Total RNA-seq data. It takes rRNA-depleted reads (unmappable to rRNA sequences) as input and maps them uniquely or multi-friendly.

CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

STARdate=$(date +"%y%m%d")

echo '' > STAR$STARdate.condor
echo '' > STARtranscriptomebams
printf '''
universe=vanilla
log=align-star-$(Process).log
output=align-star-$(Process).out
error=align-star-$(Process).err

STAR_DIR=/woldlab/castor/proj/programs/STAR-2.5.2a/bin/Linux_x86_64/

request_cpus = 8
request_memory = 30G
request_disk = 60G

executable=$(STAR_DIR)STAR
transfer_executable=false

should_transfer_files=Always
when_to_transfer_output=ON_EXIT
transfer_input_files=/woldlab/loxcyc/home/phe/programs/SamtoolsSort.sh

''' >> STAR$STARdate.condor

while read path
    do
        if [[ "$4" == "PE" ]]
            then
                READ1=$(echo $path"allfastqrRNAUnmapped"$3"_1".fastq)
                READ2=$(echo $path"allfastqrRNAUnmapped"$3"_2".fastq)
                EXTRA_ARGS=""
        elif [[ "$4" == "SE" ]]
            then
                READ1=$(echo $path"allfastqrRNAUnmapped"$3.fastq)
                READ2=""
                EXTRA_ARGS="--outSAMstrandField intronMotif"
        fi

        echo -e 'arguments="--genomeDir' $STARDir \
            '--readFilesIn' $READ1 $READ2 \
            '--runThreadN' 8 \
            '--genomeLoad NoSharedMemory' \
            '--outFilterMultimapNmax 1' \
            '--alignSJoverhangMin 8' \
            '--alignSJDBoverhangMin 1' \
            '--outFilterMismatchNmax 999' \
            '--outFilterMismatchNoverReadLmax 0.04' \
            '--alignIntronMin 20' \
            '--alignIntronMax 1000000' \
            '--alignMatesGapMax 1000000' \
            '--outSAMheaderCommentFile COfile.txt' \
            '--outSAMheaderHD @HD VN:1.4 SO:coordinate' \
            '--outSAMunmapped Within' \
            '--outFilterType BySJout' \
            '--outSAMattributes NH HI AS NM MD' \
            '--outSAMtype BAM SortedByCoordinate' \
            '--quantMode TranscriptomeSAM GeneCounts' \
            '--sjdbScore 1' \
            '--limitBAMsortRAM 30000000000' \
            '--outFileNamePrefix '$path'FastQCk6/Unique/'$2'.'$3'mer' \
            $EXTRA_ARGS' "' >> STAR$STARdate.condor
        echo -e '+PostCmd="SamtoolsSort.sh"\n+PostArguments="'$path'FastQCk6/Unique/'$2'.'$3'merAligned.toTranscriptome.out.bam"\nqueue\n'>> STAR$STARdate.condor
#        echo -e 'arguments="--genomeDir' $STARDir \
#            '--readFilesIn' $READ1 $READ2 \
#            '--runThreadN' 8 \
#            '--genomeLoad NoSharedMemory' \
#            '--outFilterMultimapNmax 10000' \
#            '--alignSJoverhangMin 8' \
#            '--alignSJDBoverhangMin 1' \
#            '--outFilterMismatchNmax 999' \
#            '--outFilterMismatchNoverReadLmax 0.001' \
#            '--alignIntronMin 20' \
#            '--alignIntronMax 1000000' \
#            '--alignMatesGapMax 1000000' \
#            '--outSAMheaderCommentFile COfile.txt' \
#            '--outSAMheaderHD @HD VN:1.4 SO:coordinate' \
#            '--outSAMunmapped Within' \
#            '--outFilterType BySJout' \
#            '--outSAMattributes NH HI AS NM MD' \
#            '--outSAMtype BAM SortedByCoordinate' \
#            '--quantMode TranscriptomeSAM GeneCounts' \
#            '--sjdbScore 1' \
#            '--limitBAMsortRAM 30000000000' \
#            '--outFileNamePrefix '$path'FastQCk6/Multi/'$2'.'$3'mer' \
#            $EXTRA_ARGS' "' >> STAR$STARdate.condor
#        echo -e '+PostCmd="SamtoolsSort.sh"\n+PostArguments="'$path'FastQCk6/Multi'$2'.'$3'merAligned.toTranscriptome.out.bam"\nqueue\n'>> STAR$STARdate.condor
    done <$1

printf "ls *k6/Unique/*ReadsPerGene.out.tab > STAR.genes.list\n" >> testcode
printf "awk '{print \$1}' \$(head -1 STAR.genes.list) > ReadsPerGenes\n" >> testcode
printf "while read ReadsPerGene; do paste -d \"|\" ReadsPerGenes <(awk '{print \$4}' \$ReadsPerGene) > temp; mv temp ReadsPerGenes; done<STAR.genes.list\n" >> testcode
printf "paste -d \"|\" <(echo \"SampleName\") <(cat testFolderPath | paste -s -d \"|\") | cat - ReadsPerGenes > temp && mv temp ReadsPerGenes\n" >> testcode
printf "ls *rRNA.*.err > Bowtie.err.list\n" >> testcode
printf "paste <(echo \"Sequenced\";echo \"rRNA\";echo \"NonrRNA\") > BowtieStats\n" >> testcode
printf "while read BowtieStat; do paste -d \"|\" BowtieStats <(grep \"#\" \$BowtieStat | cut -d: -f2) > temp; mv temp BowtieStats; done<Bowtie.err.list\n" >> testcode
printf "ls *k6/Unique/dm3.50merLog.final.out > STAR.stats.list\n" >> testcode
printf "cut -d \"|\" -f1 \$(head -1 STAR.stats.list) > STARstats\n" >> testcode
printf "while read STARstat; do paste -d \"|\" STARstats <(cut -d \"|\" -f2 \$STARstat ) > temp; mv temp STARstats; done<STAR.stats.list\n" >> testcode
