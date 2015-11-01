#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/Stats.sh testFolderPath mm9 30mer

echo '' >> testcode
echo '' >> testcode

CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "Summarizing all the scores" >> testcode
echo "*****************" >> testcode



#creating the header
if [ "$2" == "mm9" ]
    then
        printf '''
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaks HOMERpeaks processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chrX_reads chrY_reads chrM_reads chrUn_reads chrUnmapped" >> stats
        ''' >> testcode
elif [ "$2" == "mm10" ]
    then
        printf '''
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaks HOMERpeaks processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chrX_reads chrY_reads chrM_reads chrUn_reads chrUnmapped" >> stats
        ''' >> testcode
elif [ "$2" == "hg19male" ]
    then
        printf '''
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaks HOMERpeaks processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chr20_reads chr21_reads chr22_reads chrX_reads chrY_reads chrM_reads chrUnmapped" >> stats
        ''' >> testcode
elif [ "$2" == "hg19female" ]
    then
        printf '''
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaks HOMERpeaks processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chr20_reads chr21_reads chr22_reads chrX_reads chrM_reads chrUnmapped" >> stats
        ''' >> testcode
else exit "error in genome version"
fi



#creating the body
printf '''
declare -i k=0
while read line
    do
        echo -n $line.'$2'.'$3' $(if [ -e $line.'$2'.'$3'mer.SAMstats ]; then cat $line.'$2'.'$3'mer.SAMstats | grep Complexity | cut -f2; else echo 0; fi) $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.SAMstats ]; then cat $line.'$2'.'$3'mer.unique.nochrM.SAMstats | grep Complexity | cut -f2; else echo 0; fi) $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.3x.2RPM.bed ]; then wc -l $line.'$2'.'$3'mer.unique.nochrM.3x.2RPM.bed | cut -d" " -f1; else echo 0; fi) $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.5x.4RPM.bed ]; then wc -l $line.'$2'.'$3'mer.unique.nochrM.5x.4RPM.bed | cut -d" " -f1; else echo 0; fi) $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.bed ]; then wc -l $line.'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.bed | cut -d" " -f1; else echo 0; fi) $(if [ -e $line.'$2'.'$3'merlS50000mD50s150fL0.bed ]; then wc -l $line.'$2'.'$3'merlS50000mD50s150fL0.bed | cut -d" " -f1; else echo 0; fi) $(cat shell.$k.err | grep processed - | cut -d: -f2) $(cat shell.$k.err | grep least - | cut -d: -f2 | cut -d"(" -f1 ) $(cat shell.$k.err | grep failed - | cut -d: -f2 | cut -d"(" -f1 ) $(cat shell.$k.err | grep suppressed - | cut -d: -f2 | cut -d"(" -f1 ) " " >> stats
''' >> testcode

if [ "$2" == "mm9" ]
    then
        for i in {1..19} 'X' 'Y' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' "\$line"."$2"."$3"mer.idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
                    done
        echo "        chrUn_reads=\$(egrep -w 'chrUn_random' "\$line"."$2"."$3"mer.idxstats | cut -f3)" >> testcode
        echo "        chrUnmapped=\$(egrep -w '*' "\$line"."$2"."$3"mer.idxstats | cut -f4)" >> testcode

        printf '''
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads $chrUn_reads $chrUnmapped >> stats
        ''' >> testcode
elif [ "$2" == "mm10" ]
    then
        for i in {1..19} 'X' 'Y' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i" |chr"$i".*_random' "\$line"."$2"."$3"mer.idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
            done
        echo "        chrUn_reads=\$(egrep -w 'chrUn.*' "\$line"."$2"."$3"mer.idxstats | cut -f3)" >> testcode
        echo "        chrUnmapped=\$(egrep -w '*' "\$line"."$2"."$3"mer.idxstats | cut -f4)" >> testcode
        printf '''
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads $chrUn_reads $chrUnmapped >> stats
        ''' >> testcode
elif [ "$2" == "hg19male" ]
    then
        for i in {1..22} 'X' 'Y' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' "\$line"."$2"."$3"mer.idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
            done

        echo "        chrUnmapped=\$(egrep -w '*' "\$line"."$2"."$3"mer.idxstats | cut -f4)" >> testcode
        printf '''
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chr20_reads $chr21_reads $chr22_reads $chrX_reads $chrY_reads $chrM_reads $chrUnmapped >> stats
        ''' >> testcode
elif [ "$2" == "hg19female" ]
    then
        for i in {1..22} 'X' 'M'
            do
                echo "        chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' "\$line"."$2"."$3"mer.idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
            done
        echo "        chrUnmapped=\$(egrep -w '*' "\$line"."$2"."$3"mer.idxstats | cut -f4)" >> testcode
        printf '''
            echo $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chr20_reads $chr21_reads $chr22_reads $chrX_reads $chrM_reads         $chrUnmapped >> stats
        ''' >> testcode
else exit "error in genome version"
fi

printf '''
    k=$k+1
    done <'$1'
''' >> testcode



