#!/bin/bash
#this script is part of the refolder scripts which trims reads and runs fastQC
#FastQCTrim.sh PE $path 30
if [[ "$1" == "PE" ]] #this part is not coded correct since we only do SE
    then
        printf "cat "$2"*R1.fastq > "$2"R1all.fastq && " >> testcode
        printf "cat "$2"*R2.fastq > "$2"R2all.fastq && " >> testcode
        printf "mkdir -p "$2"FastQCk6R1 && " >> testcode
        printf "mkdir -p "$2"FastQCk6R2 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R1all.fastq -o "$2"FastQCk6R1 -k 6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R2all.fastq -o "$2"FastQCk6R2 -k 6 && " >> testcode
        printf "~/.local/bin/cutadapt -a CTGTCTCTTATACAC "$2"R1all.fastq | ~/.local/bin/cutadapt -a CGTATGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g TGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g GGTAACTTTGTGTTT - | ~/.local/bin/cutadapt -g CTTTGTGTTTGA - | ~/.local/bin/cutadapt -a CACTCGTCGGCAGCGTTAGATGTGTATAAG - > "$2"R1trimmedfastq && " >> testcode
        printf "~/.local/bin/cutadapt -a CTGTCTCTTATACAC "$2"R2all.fastq | ~/.local/bin/cutadapt -a CGTATGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g TGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g GGTAACTTTGTGTTT - | ~/.local/bin/cutadapt -g CTTTGTGTTTGA - | ~/.local/bin/cutadapt -a CACTCGTCGGCAGCGTTAGATGTGTATAAG - > "$2"R2trimmedfastq && " >> testcode
        printf "java -jar /woldlab/castor/proj/programs/Trimmomatic-0.33/trimmomatic-0.33.jar PE -threads 4 -trimlog "$2"trimmomatic.log "$2"R1trimmedfastq "$2"R2trimmedfastq "$2"R1allpairedfastq "$2"R1allunpairedfastq "$2"R2allpairedfastq "$2"R2allunpairedfastq ILLUMINACLIP:/woldlab/castor/home/phe/genomes/AllAdaptors.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:"$(($3==0?20:$3))" && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R1allpairedfastq -o "$2"FastQCk6R1 -k 6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R2allpairedfastq -o "$2"FastQCk6R2 -k 6 && " >> testcode
        if [[ "$3" == "0" ]]
            then
                printf "mv "$2"R1allpairedfastq "$2"R1allfastq"$3" && " >> testcode
                printf "mv "$2"R2allpairedfastq "$2"R2allfastq"$3" && " >> testcode
        else
            printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$2"R1allpairedfastq "$3" -stdout > "$2"R1allfastq"$3" && " >> testcode
            printf "python /woldlab/castor/home/georgi/code/trimfastq.py "$2"R2allpairedfastq "$3" -stdout > "$2"R2allfastq"$3" && " >> testcode
        fi    
elif [[ "$1" == "SE" ]]
    then
        printf "cat "$2"*.fastq > "$2"all.fastq && " >> testcode
        printf "mkdir -p "$2"FastQCk6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"all.fastq -o "$2"FastQCk6 -k 6 && " >> testcode
        printf "~/.local/bin/cutadapt -f fastq -a AGATCGGAAGAGCACACGTCT -O 6 -m 6 -o "$2"all.trimmed.fastq -n 3 --too-short-output="$2"all.tooshort.fastq --untrimmed-output="$2"all.untrimmed.fastq -e 0.15 "$2"all.fastq && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"all.trimmed.fastq -o "$2"FastQCk6 -k 6 && " >> testcode
        printf "/woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie --best --un "$2"all.trimmed_filtered.fastq ~/genomes/K-12W3110/bowtie1-index/K-12W3110rRNA "$2"all.trimmed.fastq "$2"all.trimmed.map 2> "$2"all.trimmed.err && " >> testcode
        printf "/woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie -m 1 --best -strata --sam ~/genomes/K-12W3110/bowtie1-index/K-12W3110 "$2"all.trimmed_filtered.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT ~/genomes/K-12W3110/K-12W3110.fasta - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$2"all.trimmed_filtered.W3110 && " >> testcode
        printf "/woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie -m 1 --best -strata ~/genomes/K-12W3110/bowtie1-index/K-12W3110 "$2"all.trimmed_filtered.fastq "$2"all.trimmed_filtered.map 2> "$2"all.trimmed_filtered.err && " >> testcode       
        printf "/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$2"all.trimmed_filtered.W3110.bam && " >> testcode
        printf "/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools rmdup -s "$2"all.trimmed_filtered.W3110.bam "$2"all.trimmed_filtered.W3110.rmdup.bam && " >> testcode
        printf "python ~/171102ShuaiWangRibo/SupplementaryNote2.py "$2"all.trimmed_filtered.map "$2"all.trimmed_filtered.pos "$2"all.trimmed_filtered.neg && " >> testcode
        printf "python ~/171102ShuaiWangRibo/SupplementaryNote3.py "$2"all.trimmed_filtered.pos "$2"all.trimmed_filtered.neg "$2"all.trimmed_filtered.readcount && " >> testcode
        printf "python ~/171102ShuaiWangRibo/SupplementaryNote4.py "$2"all.trimmed_filtered.pos "$2"all.trimmed_filtered.neg ~/171102ShuaiWangRibo/GenesPos ~/171102ShuaiWangRibo/GenesNeg "$2"all.trimmed_filtered.posgene "$2"all.trimmed_filtered.neggene && " >> testcode
        printf "python ~/171102ShuaiWangRibo/SupplementaryNote6.py "$2"all.trimmed_filtered.pos "$2"all.trimmed_filtered.neg "$2"all.trimmed_filtered.readcount "$2"all.trimmed_filtered.posRPM "$2"all.trimmed_filtered.negRPM && " >> testcode
        printf "python ~/171102ShuaiWangRibo/SupplementaryNote7.py "$2"all.trimmed_filtered.posRPM "$2"all.trimmed_filtered.negRPM "$2"all.trimmed_filtered.posRPMcomplete "$2"all.trimmed_filtered.negRPMcomplete && " >> testcode
        printf "python ~/171102ShuaiWangRibo/SupplementaryNote8.py "$2"all.trimmed_filtered.posRPMcomplete "$2"all.trimmed_filtered.negRPMcomplete ~/171102ShuaiWangRibo/GenesPos ~/171102ShuaiWangRibo/GenesNeg "$2"all.trimmed_filtered.posRPMcompleteGene "$2"all.trimmed_filtered.negRPMcompleteGene && " >> testcode
        printf "python ~/171102ShuaiWangRibo/SupplementaryNote12.py "$2"all.trimmed_filtered.pos "$2"all.trimmed_filtered.neg ~/171102ShuaiWangRibo/GenesPos ~/171102ShuaiWangRibo/GenesNeg "$2"all.trimmed_filtered.ave && " >> testcode
        printf "python ~/171102ShuaiWangRibo/SupplementaryNote13.py "$2"all.trimmed_filtered.pos "$2"all.trimmed_filtered.neg ~/171102ShuaiWangRibo/GenesPos ~/171102ShuaiWangRibo/GenesNeg "$2"all.trimmed_filtered.avestop && " >> testcode
fi
printf "rm "$2"*fastq & \n" >> testcode

