#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/eRangeCode.sh testFolderPath mm9 36mer

echo '' >> testcodeeRange
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeeRange
echo "#eRange(makeRds, findall, regiontobed, bedtobigbed) codes:" >> testcodeeRange
echo "#*****************\nrm *.rds *.rds.log; " >> testcodeeRange


while read line
    do
        printf "condor_run -a request_memory=30000 \"python /woldlab/castor/home/georgi/code/erange-4.0a/MakeRdsFromBam5.py reads "$line"."$2"."$3".unique.dup.nochrM.bam "$line"."$2"."$3".unique.nochrM.rds --index --cache=20000000 && " >> testcodeeRange
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line"."$2"."$3".unique.nochrM.3x.2RPM- "$line"."$2"."$3".unique.nochrM.rds "$line"."$2"."$3".unique.nochrM.3x.2RPM.hts -minimum 2 -ratio 3 -listPeak -cache 20000000 -nodirectionality -log "$line"."$2"."$3".unique.nochrM.3x.2RPM.err && " >> testcodeeRange
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line"."$2"."$3".unique.nochrM.5x.4RPM- "$line"."$2"."$3".unique.nochrM.rds "$line"."$2"."$3".unique.nochrM.5x.4RPM.hts -minimum 4 -ratio 5 -listPeak -cache 20000000 -nodirectionality -log "$line"."$2"."$3".unique.nochrM.5x.4RPM.err && rm "$line"."$2"."$3".unique.nochrM.rds && rm "$line"."$2"."$3".unique.nochrM.rds.log && " >> testcodeeRange
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line"."$2"."$3".unique.nochrM.3x.2RPM.hts "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed -nolabel && " >> testcodeeRange
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line"."$2"."$3".unique.nochrM.5x.4RPM.hts "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed -nolabel \" && " >> testcodeeRange
        printf "sort -k 1d,1 -k 2n,3 "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed | intersectBed -a - -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3".unique.nochrM.3x.2RPM.clean.bed && mv "$line"."$2"."$3".unique.nochrM.3x.2RPM.clean.bed "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed && " >> testcodeeRange
        printf "sort -k 1d,1 -k 2n,3 "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed | /usr/bin/intersectBed -a - -b ~/genomes/mm9/mm9-blacklist.bed -v | intersectBed -a - -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3".unique.nochrM.5x.4RPM.clean.bed && mv "$line"."$2"."$3".unique.nochrM.5x.4RPM.clean.bed "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed && " >> testcodeeRange
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.3x.2RPM.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.3x.2RPM.bigBed && " >> testcodeeRange
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.5x.4RPM.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.5x.4RPM.bigBed & \n" >> testcodeeRange
    done <$1

chmod a+x testcodeeRange


