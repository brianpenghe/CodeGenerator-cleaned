#!/bin/bash
#usage: ./Coverage STARoutputPrefixAligned.sortedByCoord gtf chromsizes


uniquewig=$(echo -e $1"Signal.Unique.str1.out.bg")
allwig=$(echo -e $1"Signal.UniqueMultiple.str1.out.bg")

python /woldlab/castor/home/sau/code/gene_coverage_wig_gtf.py $2 $uniquewig 1000 $1".coverage"
/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig -clip $uniquewig $3 $uniquewig.bigWig
/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig -clip $allwig $3 $allwig.bigWig
