#!/bin/bash
#usage: ./Coverage STARoutputPrefixAligned.sortedByCoord gtf

uniquewig=$(echo -e $1"Signal.Unique.str1.out.bg")
allwig=$(echo -e $1"Signal.UniqueMultiple.str1.out.bg")

python /woldlab/castor/home/sau/code/gene_coverage_wig_gtf.py $2 $uniquewig 1000 $1".coverage"
