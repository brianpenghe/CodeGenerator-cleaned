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
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2"."$3".unique.bam  "$chromsizes" "$line"."$2"."$3".unique.5prime.wig -notitle -uniqueBAM -RPM\" && " >> testcodebigWig
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2"."$3".unique.bam  "$chromsizes" "$line"."$2"."$3".unique.5prime.plus.wig -stranded + -notitle -uniqueBAM -RPM\" && " >> testcodebigWig
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2"."$3".unique.bam  "$chromsizes" "$line"."$2"."$3".unique.5prime.minus.wig -stranded - -notitle -uniqueBAM -RPM\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.plus.bg4 "$chromsizes" "$line"."$2"."$3".unique.plus.bigWig\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.minus.bg4 "$chromsizes" "$line"."$2"."$3".unique.minus.bigWig\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.bg4 "$chromsizes" "$line"."$2"."$3".unique.bigWig\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.5prime.plus.wig "$chromsizes" "$line"."$2"."$3".unique.5prime.plus.bigWig\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.5prime.minus.wig "$chromsizes" "$line"."$2"."$3".unique.5prime.minus.bigWig\" && " >> testcodebigWig
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.5prime.wig "$chromsizes" "$line"."$2"."$3".unique.5prime.bigWig\" & \n" >> testcodebigWig
    done <$1



/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

echo '' >> testcode
echo "Mitochondria-Sex-reports codes:" >> testcode
echo "******************" >> testcode

printf '''
    echo "file chrXYM_reads" > chr_reads
    for file in *.idxstats
        do
''' >> testcode

if [ "$2" == "mm9" ]
then
    for i in {1..19} 'X' 'Y' 'M'
        do
            echo "      chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' \$file | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
        done
        echo "      chrUn_reads=\$(egrep -w 'chrUn_random' \$file | cut -f3)" >> testcode
        echo "      chrUnmapped=\$(egrep -w '*' \$file | cut -f4)" >> testcode
    printf '''
        echo $file $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads $chrUn_reads $chrUnmapped >> chr_reads
        done
    ''' >> testcode
elif [ "$2" == "mm10" ]
then
    for i in {1..19} 'X' 'Y' 'M'
        do
            echo "      chr"$i"_reads=\$(egrep -w 'chr"$i" |chr"$i".*_random' \$file | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
        done
    echo "      chrUn_reads=\$(egrep -w 'chrUn.*' \$file | cut -f3)" >> testcode
    echo "      chrUnmapped=\$(egrep -w '*' \$file | cut -f4)" >> testcode
    printf '''
    echo $file $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads $chrUn_reads $chrUnmapped >> chr_reads
done
''' >> testcode
elif [ "$2" == "hg19male" ]
then
    for i in {1..22} 'X' 'Y' 'M'
        do
            echo "      chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' \$file | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
        done

        echo "      chrUnmapped=\$(egrep -w '*' \$file | cut -f4)" >> testcode
    printf '''
        echo $file $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chr20_reads $chr21_reads $chr22_reads $chrX_reads $chrY_reads $chrM_reads $chrUnmapped >> chr_reads
        done
    ''' >> testcode
elif [ "$2" == "hg19female" ]
then
    for i in {1..22} 'X' 'M'
        do
            echo "      chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' \$file | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
        done

    echo "      chrUnmapped=\$(egrep -w '*' \$file | cut -f4)" >> testcode
    printf '''
        echo $file $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chr20_reads $chr21_reads $chr22_reads $chrX_reads $chrM_reads $chrUnmapped >> chr_reads
        done
    ''' >> testcode
fi






