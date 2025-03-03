#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/bigWigCode.sh test mm9 36mer

echo '' >> testcodebigWig
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodebigWig
echo "#bigWig (bedgraph, make5prime, wigToBigwig) codes:" >> testcodebigWig
echo "#*****************" >> testcodebigWig

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcodebigWig
while read line
    do
        printf "condor_run -a request_memory=20000 \"python /woldlab/castor/home/georgi/code/makewigglefromBAM-NH.py --- "$line"."$2"."$3".unique.dup.nochrM.bam "$chromsizes" "$line"."$2"."$3".unique.bg4 -notitle -uniqueBAM -RPM\" && " >> testcodebigWig
        printf "condor_run -a request_memory=20000 \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig -clip "$line"."$2"."$3".unique.bg4 "$chromsizes" "$line"."$2"."$3".unique.bigWig\" & \n" >> testcodebigWig
    done <$1

chmod a+x testcodebigWig
