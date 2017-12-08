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

RSEM_DIR=/woldlab/castor/home/diane/proj/long-rna-seq-pipeline/rsem/

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
                '--temporary-folder' $CurrentLo/temp \
                $path"."$2"."$3"merAligned.toTranscriptome.out.sorted.bam" $RsemDir $path"."$2"."$3"merAligned.toTranscriptome.out.sorted.rsem" \
                '"\nqueue\n'>> Rsem$Rsemdate.condor
    done <$1
