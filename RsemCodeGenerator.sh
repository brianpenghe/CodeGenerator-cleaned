#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed

#usage: ./RsemCodeGenerator.sh testFolderPath mm9 30 PE
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

Rsemdate=$(date +"%y%m%d")

echo '' > Rsem$Rsemdate.condor
printf '''
universe=vanilla
log=rsem-$(Process).log
output=rsem-$(Process).out
error=rsem-$(Process).err
environment="PATH=/usr/local/bin:/usr/bin:/bin"

RSEM_DIR=/woldlab/loxcyc/home/diane/proj/long-rna-seq-pipeline/rsem/

request_cpus = 8
request_memory = 42G

executable=$(RSEM_DIR)rsem-calculate-expression
transfer_executable=false
should_transfer_files=IF_NEEDED

''' >> Rsem$Rsemdate.condor
echo "initialdir="$CurrentLo >> Rsem$Rsemdate.condor
if [[ "$4" == "PE" ]]
    then
        PEparameter="--paired-end --forward-prob 0.5"
elif [[ "$4" == "SE" ]]
    then
        PEparameter=""
fi

while read path
    do
        echo -e 'arguments="--bam --estimate-rspd --calc-ci' --seed 12345 -p 8 \
                '--no-bam-output --ci-memory 30000 '$PEparameter \
                '--temporary-folder' $path"FastQCk6/temp" \
                $path"FastQCk6/"$2"."$3"merAligned.toTranscriptome.out.sorted.bam" \
                $RsemDir \
                $path"FastQCk6/"$2"."$3"merAligned.toTranscriptome.out.sorted.rsem" \
                '"\nqueue\n'>> Rsem$Rsemdate.condor
    done <$1

printf "ls *k6/*genes.results > rsem.genes.results.list\n" >> testcode
printf "ls *k6/*isoforms.results > rsem.isoforms.results.list\n" >> testcode
printf "awk '{print \$1\"\\\t\"\$2\"\\\t\"}' \$(head -1 rsem.genes.results.list) > FPKM.genes\n" >> testcode
printf "awk '{print \$1\"\\\t\"\$2\"\\\t\"}' \$(head -1 rsem.isoforms.results.list) > FPKM.isoforms\n" >> testcode
printf "awk '{print \$1\"\\\t\"\$2\"\\\t\"}' \$(head -1 rsem.genes.results.list) > count.genes\n" >> testcode
printf "awk '{print \$1\"\\\t\"\$2\"\\\t\"}' \$(head -1 rsem.isoforms.results.list) > count.isoforms\n" >> testcode
printf "while read rsem; do paste FPKM.genes <(awk '{print \$7}' \$rsem) > temp; mv temp FPKM.genes; done<rsem.genes.results.list\n" >> testcode
printf "while read rsem; do paste count.genes <(awk '{print \$5}' \$rsem) > temp; mv temp count.genes; done<rsem.genes.results.list\n" >> testcode
printf "while read rsem; do paste FPKM.isoforms <(awk '{print \$7}' \$rsem) > temp; mv temp FPKM.isoforms; done<rsem.isoforms.results.list\n" >> testcode
printf "while read rsem; do paste count.isoforms <(awk '{print \$5}' \$rsem) > temp; mv temp count.isoforms; done<rsem.isoforms.results.list\n" >> testcode
printf "paste <(head -1 FPKM.genes | awk '{print \$1\"\\\t\"\$2\"\\\t\"}') <(cat testFolderPath | paste -s) | cat - <(tail -n +2 FPKM.genes) | paste $GeneNames - > temp && mv temp FPKM.genes\n" >> testcode
printf "paste <(head -1 count.genes | awk '{print \$1\"\\\t\"\$2\"\\\t\"}') <(cat testFolderPath | paste -s) | cat - <(tail -n +2 count.genes) | paste $GeneNames - > temp && mv temp count.genes\n" >> testcode
printf "paste <(head -1 FPKM.isoforms | awk '{print \$1\"\\\t\"\$2\"\\\t\"}') <(cat testFolderPath | paste -s) | cat - <(tail -n +2 FPKM.isoforms) > temp && mv temp FPKM.isoforms\n" >> testcode
printf "paste <(head -1 count.isoforms | awk '{print \$1\"\\\t\"\$2\"\\\t\"}') <(cat testFolderPath | paste -s) | cat - <(tail -n +2 count.isoforms) > temp && mv temp count.isoforms\n" >> testcode
