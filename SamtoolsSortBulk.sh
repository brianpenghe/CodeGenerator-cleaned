#!/bin/bash
#Bulk sort with default naming method
#the file $bam is just a list of bam files for sorting
#usage: ./SamtoolsSort.sh bams

while read bam
    do
        /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort $bam $(echo $bam | rev | cut -d. -f2- | rev).sorted &&
        /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index $(echo $bam | rev | cut -d. -f2- | rev).sorted.bam &
    done<$1
