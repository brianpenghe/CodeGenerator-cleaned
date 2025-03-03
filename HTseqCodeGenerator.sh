#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed


#usage: ./HTseqCodeGenerator.sh testFolderPath mm9 30mer PE
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2


HTseqdate=$(date +"%y%m%d")
printf '''
universe=vanilla

executable=/bin/sh

log=HTseq.$(Process).log
output=HTseq.$(Process).out
error=HTseq.$(Process).err

request_cpus = 1
request_memory = 9000
request_disk = 0

Requirements = (Machine == "pongo.cacr.caltech.edu" || Machine == "myogenin.cacr.caltech.edu" || Machine == "mondom.cacr.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.cacr.caltech.edu")

''' >> HTseq$HTseqdate.condor

while read path
    do
        if [[ "$4" == "PE" ]]
            then
                printf "arguments=\"-c '/usr/bin/samtools view -h -f 3 "$path"."$2"."$3"mer/accepted_hits.bam | /woldlab/castor/home/phe/.local/bin/htseq-count -s no -m intersection-strict -q - "$GTF" | grep -v __ > "$path"."$2"."$3"mer.count ' \" \nqueue\n" >> HTseq$HTseqdate".condor"
        elif [[ "$4" == "SE" ]]
            then
                printf "arguments=\"-c '/usr/bin/samtools view -h -F 4 "$path"."$2"."$3"mer/accepted_hits.bam | /woldlab/castor/home/phe/.local/bin/htseq-count -s no -m intersection-strict -q - "$GTF" | grep -v __ > "$path"."$2"."$3"mer.count ' \" \nqueue\n" >> HTseq$HTseqdate".condor"
        fi
		printf $(echo $path | rev | cut -d/ -f1 | rev)"\t"$path"."$2"."$3"mer.count\t0\t1\n" >> HTseqTable
    done <$1
	
printf "python /woldlab/castor/home/georgi/code/combineIntoTable.py HTseqTable HTseqCount.table\n" >> testcode
printf "join -1 1 -2 5 HTseqCount.table ~/genomes/mm9/Mus_musculus.NCBIM37.67.filtered.gene.sorted > HTseqCount.gene\n" >> testcode