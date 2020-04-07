#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/HOMERCode.sh testFolderPath mm9 36mer

echo '' >> testcodeHOMER
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeHOMER
echo "#HOMER prepare reads, Peak calling and convert to bed(no score) codes:" >> testcodeHOMER
echo "#*****************" >> testcodeHOMER

echo "export PATH=/woldlab/loxcyc/home/phe/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/woldlab/loxcyc/proj/genome/programs/weblogo:/woldlab/loxcyc/proj/genome/programs/x86_64/blat/:/woldlab/loxcyc/proj/genome/programs/homer-4.7/bin" >> testcodeHOMER
echo "export PYTHONPATH=\$PYTHONPATH:/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/lib/python2.7/site-packages" >> testcodeHOMER

while read line
    do
        printf " /woldlab/loxcyc/proj/genome/programs/homer-4.7/bin/makeTagDirectory "$line"."$2"."$3"HomerTags "$line"."$2"."$3".unique.dup.nochrM.bam -single && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/homer-4.7/bin/findPeaks "$line"."$2"."$3"HomerTags -localSize 50000 -minDist 50 -size 150 -fragLength 0 -o "$line"."$2"."$3"lS50000mD50s150fL0.HOMER 2> "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.err && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/homer-4.7/bin/findPeaks "$line"."$2"."$3"HomerTags -localSize 50000 -fdr 0.0005 -minDist 50 -size 150 -fragLength 0 -o "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER 2> "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER.err && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/homer-4.7/bin/findPeaks "$line"."$2"."$3"HomerTags -localSize 50000 -fdr 0.0001 -minDist 50 -size 150 -fragLength 0 -o "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER 2> "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER.err && " >> testcodeHOMER
        printf "grep 000 "$line"."$2"."$3"lS50000mD50s150fL0.HOMER | grep chr - | grep -v = | awk '{print \$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t\"\$1\"\\\t\"225\"\\\t\"\$5}' - | sort -k 1d,1 -k 2n,2 > "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.whole.bed && " >> testcodeHOMER
        printf "grep 000 "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER | grep chr - | grep -v = | awk '{print \$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t\"\$1\"\\\t\"225\"\\\t\"\$5}' - | sort -k 1d,1 -k 2n,2 > "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER.whole.bed && " >> testcodeHOMER
        printf "grep 000 "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER | grep chr - | grep -v = | awk '{print \$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t\"\$1\"\\\t\"225\"\\\t\"\$5}' - | sort -k 1d,1 -k 2n,2 > "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER.whole.bed && " >> testcodeHOMER
        printf "intersectBed -a "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.whole.bed -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.bed && " >> testcodeHOMER
        printf "intersectBed -a "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER.whole.bed -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER.bed && " >> testcodeHOMER
        printf "intersectBed -a "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER.whole.bed -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER.bed && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.bigBed && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER.bigBed && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER.bigBed && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.whole.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.whole.bigBed && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER.whole.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0005.HOMER.whole.bigBed && " >> testcodeHOMER
        printf "/woldlab/loxcyc/proj/genome/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER.whole.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0fdr0.0001.HOMER.whole.bigBed && " >> testcodeHOMER
        printf "/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b "$line"."$2"."$3".unique.dup.nochrM.bam -of bedgraph -bs 1 --scaleFactor 1 --skipNonCoveredRegions --smoothLength 50 -o "$line"."$2"."$3".unique.dup.count.bg4 && " >> testcodeHOMER
        printf "bedtools random -l 150 -seed 1 -n 100000 -g "$chromsizes"  | bedtools intersect -a - -b <(bedtools slop -b 9925 -i "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.whole.bed -g "$chromsizes") -v | bedtools sort -i - > "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.background.bed && " >> testcodeHOMER
        printf ""$(echo $line | rev | cut -d/ -f1 | rev | sed -r s/[.-]/_/g)"lS50000mD50s150fL0backgroundscores=\$(bedtools intersect -u -a "$line"."$2"."$3".unique.dup.count.bg4 -b "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.background.bed | awk '{if(\$4!=0){array1+=1;arrayX+=log(\$4)/log(2);arrayXsq+=(log(\$4)/log(2))^2}} END {print arrayX/array1\" \"sqrt(arrayXsq/array1 - arrayX^2/array1^2)}') && " >> testcodeHOMER
        printf ""$(echo $line | rev | cut -d/ -f1 | rev | sed -r s/[.-]/_/g)"lS50000mD50s150fL0backgroundmean=\$(echo \$"$(echo $line | rev | cut -d/ -f1 | rev | sed -r s/[.-]/_/g)"lS50000mD50s150fL0backgroundscores | cut -d ' ' -f1) && " >> testcodeHOMER
        printf ""$(echo $line | rev | cut -d/ -f1 | rev | sed -r s/[.-]/_/g)"lS50000mD50s150fL0backgroundstd=\$(echo \$"$(echo $line | rev | cut -d/ -f1 | rev | sed -r s/[.-]/_/g)"lS50000mD50s150fL0backgroundscores | cut -d ' ' -f2) && " >> testcodeHOMER
        printf "awk '{print \$1\"\\\t\"\$2\"\\\t\"\$3\"\\\t\"2^((log(\$4)/log(2)-'\$"$(echo $line | rev | cut -d/ -f1 | rev | sed -r s/[.-]/_/g)"lS50000mD50s150fL0backgroundmean')/'\$"$(echo $line | rev | cut -d/ -f1 | rev | sed -r s/[.-]/_/g)"lS50000mD50s150fL0backgroundstd')-1}' "$line"."$2"."$3".unique.dup.count.bg4 > "$line"."$2"."$3".unique.dup.2PowZscore.bg4 && " >> testcodeHOMER
        printf "/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig -clip "$line"."$2"."$3".unique.dup.2PowZscore.bg4 "$chromsizes" "$line"."$2"."$3".unique.dup.2PowZscore.bigWig && " >> testcodeHOMER
        printf "echo 'RiP:' \$(intersectBed -abam "$line"."$2"."$3".unique.dup.bam -b "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.bed | /woldlab/loxcyc/proj/genome/programs/samtools-0.1.16/bin/samtools view -c - ) > "$line"."$2"."$3".lS50000mD50s150fL0.HOMER.stats && " >> testcodeHOMER
        printf "echo 'RiPwhole:' \$(intersectBed -abam "$line"."$2"."$3".unique.dup.bam -b "$line"."$2"."$3"lS50000mD50s150fL0.HOMER.whole.bed | /woldlab/loxcyc/proj/genome/programs/samtools-0.1.16/bin/samtools view -c - ) >> "$line"."$2"."$3".lS50000mD50s150fL0.HOMER.stats && " >> testcodeHOMER
        printf "echo 'RiChrM:' \$(/woldlab/loxcyc/proj/genome/programs/samtools-0.1.16/bin/samtools view -c "$line"."$2"."$3".unique.dup.bam chrM ) >> "$line"."$2"."$3".lS50000mD50s150fL0.HOMER.stats && " >> testcodeHOMER
        printf "echo 'Rtotal:' \$(/woldlab/loxcyc/proj/genome/programs/samtools-0.1.16/bin/samtools view -c "$line"."$2"."$3".unique.dup.bam ) >> "$line"."$2"."$3".lS50000mD50s150fL0.HOMER.stats \n" >> testcodeHOMER
    done <$1

chmod a+x testcodeHOMER




