#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/TophatbigWigCode.sh test mm9 36mer

echo '' >> testcodeTophatbigWig
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeTophatbigWig
echo "#bigWig (Index, SAMstats, idxstats, bedgraph, make5prime, wigToBigwig) codes:" >> testcodeTophatbigWig
echo "#*****************" >> testcodeTophatbigWig

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcodeTophatbigWig
while read line
    do
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"/accepted_hits.bam \" && " >> testcodeTophatbigWig
        printf "condor_run -a request_memory=20000 \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3"/accepted_hits.bam "$line"."$2"."$3"/SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcodeTophatbigWig
        printf "condor_run -a request_memory=20000 \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2"."$3"/accepted_hits.bam > "$line"."$2"."$3"/idxstats\" && " >> testcodeTophatbigWig
        printf "condor_run -a request_memory=20000 \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --unique --splice --chromonly --normalize --verbose "$line"."$2"."$3"/accepted_hits.bam "$line"."$2"."$3".tophat.wig \" && " >> testcodeTophatbigWig
        printf "condor_run -a request_memory=20000 \"python /woldlab/castor/home/georgi/code/makewigglefromBAM-NH.py --- "$line"."$2"."$3"/accepted_hits.bam "$chromsizes" "$line"."$2"."$3".tophat.All.wig -notitle -RPM\" && " >> testcodeTophatbigWig
        printf "condor_run -a request_memory=20000 \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig -clip "$line"."$2"."$3".tophat.wig "$chromsizes" "$line"."$2"."$3".tophat.bigWig\" && " >> testcodeTophatbigWig
        printf "condor_run -a request_memory=20000 \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig -clip "$line"."$2"."$3".tophat.All.wig "$chromsizes" "$line"."$2"."$3".tophat.All.bigWig\" & \n" >> testcodeTophatbigWig
    done <$1

chmod a+x testcodeTophatbigWig
