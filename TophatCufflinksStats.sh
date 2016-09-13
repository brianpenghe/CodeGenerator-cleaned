#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/TophatCufflinksStats.sh testFolderPath mm9 30mer

echo '' > testcodeTophatCufflinksStats

CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2
echo "#!/bin/bash" >> testcodeTophatCufflinksStats
echo "#Summarizing all the scores" >> testcodeTophatCufflinksStats
echo "#*****************" >> testcodeTophatCufflinksStats



#creating the header
if [ "$2" == "mm9" ]
    then
        printf '
            echo "file total_complexity processed mapped suppressed mapped2 chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chrX chrY chrM " >> stats
        ' >> testcodeTophatCufflinksStats
elif [ "$2" == "mm10" ]
    then
        printf '
            echo "file total_complexity processed mapped suppressed mapped2 chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chrX chrY chrM " >> stats
        ' >> testcodeTophatCufflinksStats
elif [ "$2" == "mm10full" ]
    then
        printf '
            echo "file total_complexity processed mapped suppressed mapped2 chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chrX chrY chrM chr1_ chr4_ chr5_ chr7_ chrX_ chrY_ chrUn_" >> stats
        ' >> testcodeTophatCufflinksStats
elif [ "$2" == "hg19male" -o "$2" == "hg38" ]
    then
        printf '
            echo "file total_complexity processed mapped suppressed mapped2 chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY chrM " >> stats
        ' >> testcodeTophatCufflinksStats
elif [ "$2" == "hg19female" ]
    then
        printf '
            echo "file total_complexity processed mapped suppressed mapped2 chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrM " >> stats
        ' >> testcodeTophatCufflinksStats
else exit "error in genome version"
fi



#creating the body
printf '
declare -i k=0
while read line
    do
        echo -n $line.'$2'.'$3' $(if [ -e $line.'$2'.'$3'mer/SAMstats ]; then cat $line.'$2'.'$3'mer/SAMstats | grep Complexity | cut -f2; else echo 0; fi) $(cat $line.'$2'.'$3'mer/logs/bowtie.left_kept_reads.log | grep processed - | cut -d: -f2) $(cat $line.'$2'.'$3'mer/logs/bowtie.left_kept_reads.log | grep least - | cut -d: -f2 | cut -d"(" -f1 ) $(cat $line.'$2'.'$3'mer/logs/bowtie.left_kept_reads.log | grep suppressed - | cut -d: -f2 | cut -d"(" -f1 ) $(cat $line.'$2'.'$3'mer/logs/bowtie.left_kept_reads.m2g_um.log | grep least - | cut -d: -f2 | cut -d"(" -f1 ) " " >> stats
' >> testcodeTophatCufflinksStats

if [ "$2" == "mm9" ]
    then
        for i in {1..19} 'X' 'Y' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i"' "\$line"."$2"."$3"mer/idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcodeTophatCufflinksStats
                    done
        printf '
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads >> stats
        ' >> testcodeTophatCufflinksStats
elif [ "$2" == "mm10" ]
    then
        for i in {1..19} 'X' 'Y' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i"' "\$line"."$2"."$3"mer/idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcodeTophatCufflinksStats
            done
        printf '
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads >> stats
        ' >> testcodeTophatCufflinksStats
elif [ "$2" == "mm10full" ]
    then
        for i in {1..19} 'X' 'Y' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i"' "\$line"."$2"."$3"mer/idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcodeTophatCufflinksStats
            done
        for i in '1_' '4_' '5_' '7_' 'X_' 'Y_' 'Un_'
            do
                echo "        chr"$i"_reads=\$(grep 'chr"$i"' "\$line"."$2"."$3"mer/idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcodeTophatCufflinksStats
        printf '
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads $chr1__reads $chr4__reads $chr5__reads $chr7__reads $chrX__reads $chrY__reads $chrUn__reads>> stats
        ' >> testcodeTophatCufflinksStats
elif [ "$2" == "hg19male" -o "$2" == "hg38" ]
    then
        for i in {1..22} 'X' 'Y' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i"' "\$line"."$2"."$3"mer/idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcodeTophatCufflinksStats
            done
        printf '
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chr20_reads $chr21_reads $chr22_reads $chrX_reads $chrY_reads $chrM_reads >> stats
        ' >> testcodeTophatCufflinksStats
elif [ "$2" == "hg19female" ]
    then
        for i in {1..22} 'X' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i"' "\$line"."$2"."$3"mer/idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcodeTophatCufflinksStats
            done
        printf '
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chr20_reads $chr21_reads $chr22_reads $chrX_reads $chrM_reads >> stats
        ' >> testcodeTophatCufflinksStats
else exit "error in genome version"
fi

printf '
    k=$k+1
    done <'$1'
' >> testcodeTophatCufflinksStats

printf '
    python /woldlab/castor/home/georgi/code/combineIntoTable.py CufflinksgeneFPKMs CufflinksgeneFPKMs.table
    python /woldlab/castor/home/georgi/code/combineIntoTable.py CufflinksgeneConflows CufflinksgeneConflows.table
    python /woldlab/castor/home/georgi/code/combineIntoTable.py CufflinksisoformFPKMs CufflinksisoformFPKMs.table
    python /woldlab/castor/home/georgi/code/combineIntoTable.py CufflinksisoformConflows CufflinksisoformConflows.table
' >> testcodeTophatCufflinksStats

chmod a+x testcodeTophatCufflinksStats
