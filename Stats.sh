#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/bigWigCode.sh test mm9 36mer

echo '' >> testcode
echo '' >> testcode

CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2


echo "******************" >> testcode
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


echo "" >> testcode
echo "******************" >> testcode
echo "SAMstats and peak calling codes:" >> testcode
echo "******************" >> testcode
printf  '''
    for file in *mer.SAMstats
        do 
            echo -n $file" "  
            cat $file | grep Complexity 
        done

    for file in *nochrM.SAMstats
        do 
            echo -n $file" "  
            cat $file | grep Complexity 
        done

    for file in *.bed
        do
            echo -n $file" "
            cat $file | wc -l
        done
''' >> testcode

