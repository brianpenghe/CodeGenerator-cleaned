#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/Stats.sh testFolderPath mm9 30
#This version considers reads before duplication-removal. If you want to check stats after removal, please use *mer.idxstat files
echo '' > testcodeStats

CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeStats
echo "#Summarizing all the scores" >> testcodeStats
echo "#*****************" >> testcodeStats



#creating the header
if [ "$2" == "mm9" ]
    then
        printf '
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaksAll F-seqPeaks F-seqFRiP HOMERpeaksAll HOMERpeaks HOMERFRiP processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chrX_reads chrY_reads chrM_reads " >> stats
        ' >> testcodeStats
elif [ "$2" == "mm10" ]
    then
        printf '
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaksAll F-seqPeaks F-seqFRiP HOMERpeaksAll HOMERpeaks HOMERFRiP processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chrX_reads chrY_reads chrM_reads " >> stats
        ' >> testcodeStats
elif [ "$2" == "hg19male" -o "$2" == "hg38" ]
    then
        printf '
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaksAll F-seqPeaks F-seqFRiP HOMERpeaksAll HOMERpeaks HOMERFRiP processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chr20_reads chr21_reads chr22_reads chrX_reads chrY_reads chrM_reads " >> stats
        ' >> testcodeStats
elif [ "$2" == "hg19female" ]
    then
        printf '
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaksAll F-seqPeaks F-seqFRiP HOMERpeaksAll HOMERpeaks HOMERFRiP processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chr20_reads chr21_reads chr22_reads chrX_reads chrM_reads " >> stats
        ' >> testcodeStats
elif [ "$2" == "galGal4" ]
    then
        printf '
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaksAll F-seqPeaks F-seqFRiP HOMERpeaksAll HOMERpeaks HOMERFRiP processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chr20_reads chr21_reads chr22_reads chr23_reads chr24_reads chr25_reads chr26_reads chr27_reads chr28_reads chr32_reads chrW_reads chrZ_reads chrM_reads chrLGE64_reads " >> stats
        ' >> testcodeStats
elif [ "$2" == "strPur2" -o "$2" == "galGal4full" -o "$2" == "MG1655" ]
    then
        printf "skip stats.sh"
elif [ "$2" == "dm3" ]
    then
        printf '
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaksAll F-seqPeaks F-seqFRiP HOMERpeaksAll HOMERpeaks HOMERFRiP processed unique failed suppressed chr2L_reads chr2LHet_reads chr2R_reads chr2RHet_reads chr3L_reads chr3LHet_reads chr3R_reads chr3RHet_reads chr4_reads chrU_reads chrUextra_reads chrX_reads chrXHet_reads chrYHet_reads chrM_reads " >> stats
        ' >> testcodeStats
elif [ "$2" == "danRer10" ]
    then
        printf '
            echo "file total_complexity nucleus_complexity eRange3x2Peaks eRange5x4Peaks F-seqPeaksAll F-seqPeaks F-seqFRiP HOMERpeaksAll HOMERpeaks HOMERFRiP processed unique failed suppressed chr1_reads chr2_reads chr3_reads chr4_reads chr5_reads chr6_reads chr7_reads chr8_reads chr9_reads chr10_reads chr11_reads chr12_reads chr13_reads chr14_reads chr15_reads chr16_reads chr17_reads chr18_reads chr19_reads chr20_reads chr21_reads chr22_reads chr23_reads chr24_reads chr25_reads chrM_reads " >> stats
        ' >> testcodeStats
else exit "error in genome version"
fi



#creating the body
printf '
declare -i k=0

while read line
    do
        echo -n $line.'$2'.'$3' \
        $(if [ -e $line.'$2'.'$3'mer.SAMstats ]; then cat $line.'$2'.'$3'mer.SAMstats | grep Complexity | cut -f2; else echo 0; fi) \
        $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.SAMstats ]; then cat $line.'$2'.'$3'mer.unique.nochrM.SAMstats | grep Complexity | cut -f2; else echo 0; fi) \
        $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.3x.2RPM.bed ]; then wc -l $line.'$2'.'$3'mer.unique.nochrM.3x.2RPM.bed | cut -d" " -f1; else echo 0; fi) \
        $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.5x.4RPM.bed ]; then wc -l $line.'$2'.'$3'mer.unique.nochrM.5x.4RPM.bed | cut -d" " -f1; else echo 0; fi) \
        $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.whole.bed ]; then wc -l $line.'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.whole.bed | cut -d" " -f1; else echo 0; fi) \
        $(if [ -e $line.'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.bed ]; then wc -l $line.'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.bed | cut -d" " -f1; else echo 0; fi) \
        $(echo "scale=3; ( $(cat "$line".'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.stats | grep RiP: - | cut -d: -f2) / ($(cat "$line".'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.stats | grep total - | cut -d: -f2)-($(cat "$line".'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.stats | grep whole - | cut -d: -f2)-$(cat "$line".'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.stats | grep RiP: - | cut -d: -f2))-$(cat "$line".'$2'.'$3'mer.unique.nochrM.Fseq.v.f0.stats | grep RiChrM: - | cut -d: -f2)) )" | bc -l) \
        $(if [ -e $line.'$2'.'$3'merlS50000mD50s150fL0.whole.bed ]; then wc -l $line.'$2'.'$3'merlS50000mD50s150fL0.whole.bed | cut -d" " -f1; else echo 0; fi) \
        $(if [ -e $line.'$2'.'$3'merlS50000mD50s150fL0.bed ]; then wc -l $line.'$2'.'$3'merlS50000mD50s150fL0.bed | cut -d" " -f1; else echo 0; fi) \
        $(echo "scale=3; ( $(cat "$line".'$2'.'$3'mer.lS50000mD50s150fL0.stats | grep RiP: - | cut -d: -f2) / ($(cat "$line".'$2'.'$3'mer.lS50000mD50s150fL0.stats | grep total - | cut -d: -f2)-($(cat "$line".'$2'.'$3'mer.lS50000mD50s150fL0.stats | grep whole - | cut -d: -f2)-$(cat "$line".'$2'.'$3'mer.lS50000mD50s150fL0.stats | grep RiP: - | cut -d: -f2))-$(cat "$line".'$2'.'$3'mer.lS50000mD50s150fL0.stats | grep RiChrM: - | cut -d: -f2)) )" | bc -l) \
        $(cat shell.$k.err | grep processed - | cut -d: -f2) \
        $(cat shell.$k.err | grep least - | cut -d: -f2 | cut -d"(" -f1 ) \
        $(cat shell.$k.err | grep failed - | cut -d: -f2 | cut -d"(" -f1 ) \
        $(cat shell.$k.err | grep suppressed - | cut -d: -f2 | cut -d"(" -f1 ) " " >> stats
' >> testcodeStats

declare -A genomes
genomes["mm9"]=$(echo {1..19} 'X' 'Y' 'M')
genomes["mm9full"]=$(echo {1..19} 'X' 'Y' 'M')
genomes["mm10"]=$(echo {1..19} 'X' 'Y' 'M')
genomes["mm10full"]=$(echo {1..19} 'X' 'Y' 'M')
genomes["hg19male"]=$(echo {1..19} 'X' 'Y' 'M')
genomes["hg19female"]=$(echo {1..22} 'X' 'M')
genomes["hg38"]=$(echo {1..22} 'X' 'Y' 'M')
genomes["galGal4"]=$(echo {1..28} 32 'W' 'Z' 'M' 'LGE64')
genomes["galGal4full"]=$(echo {1..28} 32 'W' 'Z' 'M' 'LGE64')
genomes["dm3"]=$(echo '2L' '2LHet' '2R' '2RHet' '3L' '3LHet' '3R' '3RHet' '4' 'U' 'Uextra' 'X' 'XHet' 'YHet' 'M')
genomes["danRer10"]=$(echo {1..25} 'M')

printf "echo -n" >> testcodeStats 
for i in $(echo "${genomes[$2]}")
    do
        echo -n " \$(egrep -w 'chr"$i"' "\$line"."$2"."$3"mer.dup.idxstats | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcodeStats
    done
printf " >> stats\n" >> testcodeStats
printf "echo -e \"\" >> stats\n" >> testcodeStats

printf '
    k=$k+1
    done <'$1'
' >> testcodeStats

chmod a+x testcodeStats

