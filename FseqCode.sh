#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/eRangeCode.sh testFolderPath mm9 36mer

echo '' >> testcodeFseq
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeFseq
echo "#make bed, Peak calling and combine to bed(with score) codes:" >> testcodeFseq
echo "#*****************" >> testcodeFseq

while read line
    do
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/BEDTools-Version-2.10.1/bin/bamToBed -i "$line"."$2"."$3".unique.nochrM.bam > "$line"."$2"."$3".unique.nochrM.bed \" && " >> testcodeFseq
        printf "mkdir "$line"."$2"."$3"FseqResults/ && " >> testcodeFseq
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/fseq-1.84/bin/fseq -v -of bed -f 0 -o "$line"."$2"."$3"FseqResults/ "$line"."$2"."$3".unique.nochrM.bed \" && " >> testcodeFseq
        printf "cat "$line"."$2"."$3"FseqResults/*.bed | awk '{print \$1\"\\\t\"\$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t225\\\t+\"}' - | sort -k 1d,1 -k 2n,2 > "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.whole.bed && " >> testcodeFseq
        printf "grep -v chrM "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.whole.bed | intersectBed -a - -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.bed && " >> testcodeFseq
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.bigBed && " >> testcodeFseq
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.whole.bed "$chromsizes" "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.whole.bigBed && " >> testcodeFseq
        printf "echo 'RiP:' \$(intersectBed -abam $line."$2"."$3".unique.dup.bam -b $line."$2"."$3".unique.nochrM.Fseq.v.f0.bed | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view -c - ) > "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.stats && " >> testcodeFseq
        printf "echo 'RiPwhole:' \$(intersectBed -abam $line."$2"."$3".unique.dup.bam -b $line."$2"."$3".unique.nochrM.Fseq.v.f0.whole.bed | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view -c - ) >> "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.stats && " >> testcodeFseq
        printf "echo 'RiChrM:' \$(/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view -c $line."$2"."$3".unique.dup.bam chrM ) >> "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.stats && " >> testcodeFseq
        printf "echo 'Rtotal:' \$(/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view -c $line."$2"."$3".unique.dup.bam ) >> "$line"."$2"."$3".unique.nochrM.Fseq.v.f0.stats & \n" >> testcodeFseq
    done <$1

chmod a+x testcodeFseq




