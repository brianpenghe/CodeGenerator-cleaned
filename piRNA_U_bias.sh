#!/bin/bash
#piRNA_phasing.sh UBIG.vectoronly.dup.bam
SAMTOOLS=/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools
cat <($SAMTOOLS view -F 20 $1 | cut -f1,10 | grep $'\tT' | cut -f1) \
<($SAMTOOLS view -f 16 $1 | cut -f1,10 | grep 'A\>' | cut -f1) > $1.temp
wc -l $1.temp
cat <($SAMTOOLS view -H $1) <($SAMTOOLS view $1 | grep -f $1.temp - ) \
| $SAMTOOLS view -S -b - -o $1.Ubias.bam
rm $1.temp
