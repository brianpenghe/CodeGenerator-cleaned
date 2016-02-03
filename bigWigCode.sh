#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/bigWigCode.sh test mm9 36mer

echo '' >> testcodebigWig
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcodebigWig
echo "******take a break***********" >> testcodebigWig
echo "bigWig (Index, SAMstats, idxstats, bedgraph, make5prime, wigToBigwig) codes:" >> testcodebigWig
echo "*****************" >> testcodebigWig

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcodebigWig
while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.bam \" && " >> testcodebigWig
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3".unique.bam "$line"."$2"."$3".SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2"."$3".unique.bam > "$line"."$2"."$3".idxstats\" && " >> testcodebigWig
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand + --unique --splice --chromonly --normalize --verbose "$line"."$2"."$3".unique.bam "$line"."$2"."$3".unique.plus.bg4\" && " >> testcodebigWig
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand - --unique --splice --chromonly --normalize --verbose "$line"."$2"."$3".unique.bam "$line"."$2"."$3".unique.minus.bg4\" && " >> testcodebigWig
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --unique --splice --chromonly --normalize --verbose "$line"."$2"."$3".unique.bam "$line"."$2"."$3".unique.bg4\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.plus.bg4 "$chromsizes" "$line"."$2"."$3".unique.plus.bigWig\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.minus.bg4 "$chromsizes" "$line"."$2"."$3".unique.minus.bigWig\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.bg4 "$chromsizes" "$line"."$2"."$3".unique.bigWig\" && " >> testcodebigWig
    done <$1


