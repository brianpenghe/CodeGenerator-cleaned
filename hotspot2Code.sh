#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/hotspot2.sh testFolderPath mm9 36mer

echo '' >> testcodehotspot2
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodehotspot2
echo "#hotspot2 takes a bam file as input and depends on center sites and chrom_size info." >> testcodehotspot2
echo "#*****************" >> testcodehotspot2

echo "export PATH=\$PATH:/woldlab/loxcyc/proj/genome/programs/modwt/bin/" >> testcodehotspot2
echo "export PATH=\$PATH:/woldlab/castor/proj/genome/programs/x86_64/" >> testcodehotspot2
echo "export PATH=\$PATH:/woldlab/loxcyc/proj/genome/programs/hotspot2-2.1.1/bin/" >> testcodehotspot2

while read line
    do
        printf " /woldlab/loxcyc/proj/genome/programs/hotspot2-2.1.1/scripts/hotspot2.sh -f 0.1 -F 0.1 -c "$hotspot_chrom_sizes" -C "$hotspot_center_sites" "$line"."$2"."$3".unique.dup.nochrM.bam "$line"."$2"."$3"Out/ && " >> testcodehotspot2
        printf " /woldlab/loxcyc/proj/genome/programs/hotspot2-2.1.1/scripts/hsmerge.sh -f 0.05 "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.allcalls.starch "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.05.starch && " >> testcodehotspot2
        printf "unstarch "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.1.starch | grep -v chrM - | intersectBed -a - -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.1.bed && " >> testcodehotspot2
        printf "unstarch "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.05.starch | grep -v chrM - | intersectBed -a - -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.05.bed && " >> testcodehotspot2
        printf "awk '{print \$1\"\\\t\"\$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t\"\$5\"\\\t+\"}' "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.1.bed > "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.1.bed.temp && " >> testcodehotspot2 
        printf "awk '{print \$1\"\\\t\"\$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t\"\$5\"\\\t+\"}' "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.05.bed > "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.05.bed.temp && " >> testcodehotspot2
        printf "/woldlab/loxcyc/proj/genome/programs/x86_64/bedToBigBed "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.1.bed.temp "$chromsizes" "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.1.bigBed && " >> testcodehotspot2
        printf "/woldlab/loxcyc/proj/genome/programs/x86_64/bedToBigBed "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.05.bed.temp "$chromsizes" "$line"."$2"."$3"Out/"$(echo $line | rev | cut -d/ -f1 | rev)"."$2"."$3".unique.dup.nochrM.hotspots.fdr0.05.bigBed &\n" >> testcodehotspot2
    done <$1

chmod a+x testcodehotspot2




