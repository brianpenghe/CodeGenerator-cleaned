#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/STARbigWigCoverageCode.sh testFolderpath mm9 36mer

echo '' >> testcodeSTARbigWig
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeSTARbigWig
echo "#bigWig (Index, SAMstats, idxstats, bedgraph, make5prime, wigToBigwig) codes:" >> testcodeSTARbigWig
echo "#*****************" >> testcodeSTARbigWig

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcodeSTARbigWig
while read line
    do
        printf "/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"Aligned.sortedByCoord.out.bam &&  " >> testcodeSTARbigWig
        printf "python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3"Aligned.sortedByCoord.out.bam "$line"."$2"."$3".SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools && " >> testcodeSTARbigWig
        printf "/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2"."$3"Aligned.sortedByCoord.out.bam > "$line"."$2"."$3".idxstats && " >> testcodeSTARbigWig
        printf "python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --unique --splice --chromonly --normalize --verbose "$line"."$2"."$3"Aligned.sortedByCoord.out.bam "$line"."$2"."$3".STAR.wig && " >> testcodeSTARbigWig
        printf "python /woldlab/castor/home/georgi/code/makewigglefromBAM-NH.py --- "$line"."$2"."$3"Aligned.sortedByCoord.out.bam "$chromsizes" "$line"."$2"."$3".STAR.All.wig -notitle -RPM && " >> testcodeSTARbigWig
        printf "/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig -clip "$line"."$2"."$3".STAR.wig "$chromsizes" "$line"."$2"."$3".STAR.bigWig && " >> testcodeSTARbigWig
        printf "/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig -clip "$line"."$2"."$3".STAR.All.wig "$chromsizes" "$line"."$2"."$3".STAR.All.bigWig & \n" >> testcodeSTARbigWig
    done <$1

chmod a+x testcodeSTARbigWig
