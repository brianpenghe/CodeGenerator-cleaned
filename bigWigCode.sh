#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/bigWigCode.sh test mm9 36mer

echo '' >> testcode
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "bigWig (Index, SAMstats, idxstats, bedgraph, make5prime, wigToBigwig) codes:" >> testcode
echo "*****************" >> testcode

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcode
while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3".unique.bam \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2"."$3".unique.bam "$line"."$2"."$3".SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2"."$3".unique.bam > "$line"."$2"."$3".idxstats\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand + --unique --splice --chromonly --normalize --verbose "$line"."$2"."$3".unique.bam "$line"."$2"."$3".unique.plus.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand - --unique --splice --chromonly --normalize --verbose "$line"."$2"."$3".unique.bam "$line"."$2"."$3".unique.minus.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --unique --splice --chromonly --normalize --verbose "$line"."$2"."$3".unique.bam "$line"."$2"."$3".unique.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2"."$3".unique.bam  "$chromsizes" "$line"."$2"."$3".unique.5prime.wig -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2"."$3".unique.bam  "$chromsizes" "$line"."$2"."$3".unique.5prime.plus.wig -stranded + -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2"."$3".unique.bam  "$chromsizes" "$line"."$2"."$3".unique.5prime.minus.wig -stranded - -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.plus.bg4 "$chromsizes" "$line"."$2"."$3".unique.plus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.minus.bg4 "$chromsizes" "$line"."$2"."$3".unique.minus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.bg4 "$chromsizes" "$line"."$2"."$3".unique.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.5prime.plus.wig "$chromsizes" "$line"."$2"."$3".unique.5prime.plus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.5prime.minus.wig "$chromsizes" "$line"."$2"."$3".unique.5prime.minus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3".unique.5prime.wig "$chromsizes" "$line"."$2"."$3".unique.5prime.bigWig\" & \n" >> testcode
    done <$1





echo '' >> testcode
echo "Mitochondria-Sex-reports codes:" >> testcode
echo "******************" >> testcode

printf '''
    echo "file chrXYM_reads" > chrXYM_reads
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

printf "#for the following part: move the folder to public_html, then copy paste the following codes to run" >> testcode

echo '' >> testcode
echo "These are bigWig tracks:" >> testcode
echo "******************" >> testcode
printf "current_folder_name=\$(pwd|rev|cut -d '/' -f1|rev)" >> testcode
printf '''
for file in *.bigWig
    do
        echo "track type=bigWig name="$file" description="$file" maxHeightPixels=60:32:8 visibility=full color=150,0,150 bigDataUrl=http://woldlab.caltech.edu/~phe/"$current_folder_name"/"$file >> testcode
    done
''' >> testcode






