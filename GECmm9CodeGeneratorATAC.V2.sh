#!/bin/bash
#Run these codes in the current SERVER directory
#delete the testFolderPath file
#it generates three files: bowtieXXXXXX testcode & testFolderPath
echo '' > testcode
echo "wget codes:" >> testcode
echo "****************" >> testcode

CurrentLo=$(pwd)

while read line
    do
        Download=$(echo $line | sed "s/https:/http:/g")
        echo 'wget -r --no-parent --no-check-certificate '$Download' ' >> testcode
    done <test




echo '' >> testcode
echo "******take a break***********" >> testcode
echo "ATAC FastQC and bowtie.condor codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode

bowtiedate=$(date +"%y%m%d")
printf '''
universe=vanilla

executable=/bin/sh

log=shell.$(Process).log
output=shell.$(Process).out
error=shell.$(Process).err

request_cpus = 8
request_memory = 4000
request_disk = 0

Requirements = (Machine == "pongo.cacr.caltech.edu" || Machine == "myogenin.cacr.caltech.edu" || Machine == "mondom.cacr.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.cacr.caltech.edu")

''' >> bowtie$bowtiedate".condor"

while read line
    do
        Folders=$(echo $line | sed "s/https:\///g")
        SampleID=$(echo $line | rev | cut -d '/' -f2 | rev)
        FolderPath=$(echo $CurrentLo$Folders)
        echo $CurrentLo"/"$SampleID >> testFolderPath
        printf "mkdir "$CurrentLo"/"$SampleID"FastQCk6 && " >> testcode
        printf "gunzip -c "$FolderPath"*.fastq.gz > "$FolderPath"allfastq && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$FolderPath"allfastq -o "$CurrentLo"/"$SampleID"FastQCk6 -k 6 & \n" >> testcode
        printf "arguments=\"-c \'gunzip -c "$FolderPath"*.fastq.gz | python /woldlab/castor/home/georgi/code/trimfastq.py - 36 -trim5 4 -stdout | cat | /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/castor/proj/genome/bowtie-indexes/mm9 -p 8 -v 2 -k 2 -m 1 -t --sam-nh --best --strata -q --sam - | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT  /woldlab/castor/proj/genome/bowtie-indexes/mm9.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$CurrentLo"/"$SampleID".mm9.36_4mer.unique \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
        printf "arguments=\"-c \'gunzip -c "$FolderPath"*.fastq.gz | python /woldlab/castor/home/georgi/code/trimfastq.py - 36 -stdout | cat | /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/castor/proj/genome/bowtie-indexes/mm9 -p 8 -v 2 -k 2 -m 1 -t --sam-nh --best --strata -q --sam - | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT  /woldlab/castor/proj/genome/bowtie-indexes/mm9.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$CurrentLo"/"$SampleID".mm9.36mer.unique \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
    done <test



echo '' >> testcode
echo "******take a break***********" >> testcode
echo "bowtie-reports codes:" >> testcode
echo "*****************" >> testcode




printf '''
echo "file processed unique" > bowtie_report
for file in shell*err
    do
        all_reads=$(grep processed $file | cut -d':' -f2)
        unique_reads=$(grep least $file | cut -d':' -f2)
        echo $file $all_reads $unique_reads >> bowtie_report
    done

''' >> testcode


echo '' >> testcode
echo "******take a break***********" >> testcode
echo "eRange(chrM-Removal, filtermulti, index, SAMstats, makeRds, findall, regiontobed, bedtobigbed) codes:" >> testcode
echo "*****************" >> testcode


while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line".mm9.36mer.unique.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT /woldlab/castor/proj/genome/bowtie-indexes/mm9.fa - -o "$line".mm9.36mer.unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line".mm9.36mer.unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" python /woldlab/castor/home/georgi/code/filterBAMMulti.py "$line".mm9.36mer.unique.nochrM.bam /woldlab/castor/proj/programs/samtools-0.1.8/samtools 1 "$line".mm9.36mer.unique.nochrM.aligned.bam\" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line".mm9.36mer.unique.nochrM.aligned.bam \" && rm "$line".mm9.36mer.unique.nochrM.bam && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line".mm9.36mer.unique.nochrM.aligned.bam "$line".mm9.36mer.unique.nochrM.aligned.SAMstats -bam /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/erange-4.0a/MakeRdsFromBam5.py reads "$line".mm9.36mer.unique.nochrM.aligned.bam "$line".mm9.36mer.unique.nochrM.aligned.rds --index --cache=20000000\" && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line".mm9.36mer.unique.nochrM.3x.2RPM- "$line".mm9.36mer.unique.nochrM.aligned.rds "$line".mm9.36mer.unique.nochrM.3x.2RPM.hts -minimum 2 -ratio 3 -listPeak -cache 20000000 -nodirectionality && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line".mm9.36mer.unique.nochrM.5x.4RPM- "$line".mm9.36mer.unique.nochrM.aligned.rds "$line".mm9.36mer.unique.nochrM.5x.4RPM.hts -minimum 4 -ratio 5 -listPeak -cache 20000000 -nodirectionality && rm "$line".mm9.36mer.unique.nochrM.aligned.rds && rm "$line".mm9.36mer.unique.nochrM.aligned.rds.log && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line".mm9.36mer.unique.nochrM.3x.2RPM.hts "$line".mm9.36mer.unique.nochrM.3x.2RPM.bed -nolabel && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line".mm9.36mer.unique.nochrM.5x.4RPM.hts "$line".mm9.36mer.unique.nochrM.5x.4RPM.bed -nolabel && " >> testcode
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line".mm9.36mer.unique.nochrM.3x.2RPM.bed /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.nochrM.3x.2RPM.bigBed && " >> testcode
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line".mm9.36mer.unique.nochrM.5x.4RPM.bed /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.nochrM.5x.4RPM.bigBed & " >> testcode

        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line".mm9.36_4mer.unique.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT /woldlab/castor/proj/genome/bowtie-indexes/mm9.fa - -o "$line".mm9.36_4mer.unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line".mm9.36_4mer.unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" python /woldlab/castor/home/georgi/code/filterBAMMulti.py "$line".mm9.36_4mer.unique.nochrM.bam /woldlab/castor/proj/programs/samtools-0.1.8/samtools 1 "$line".mm9.36_4mer.unique.nochrM.aligned.bam\" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line".mm9.36_4mer.unique.nochrM.aligned.bam \" && rm "$line".mm9.36_4mer.unique.nochrM.bam && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line".mm9.36_4mer.unique.nochrM.aligned.bam "$line".mm9.36_4mer.unique.nochrM.aligned.SAMstats -bam /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/erange-4.0a/MakeRdsFromBam5.py reads "$line".mm9.36_4mer.unique.nochrM.aligned.bam "$line".mm9.36_4mer.unique.nochrM.aligned.rds --index --cache=20000000\" && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line".mm9.36_4mer.unique.nochrM.3x.2RPM- "$line".mm9.36_4mer.unique.nochrM.aligned.rds "$line".mm9.36_4mer.unique.nochrM.3x.2RPM.hts -minimum 2 -ratio 3 -listPeak -cache 20000000 -nodirectionality && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line".mm9.36_4mer.unique.nochrM.5x.4RPM- "$line".mm9.36_4mer.unique.nochrM.aligned.rds "$line".mm9.36_4mer.unique.nochrM.5x.4RPM.hts -minimum 4 -ratio 5 -listPeak -cache 20000000 -nodirectionality && rm "$line".mm9.36_4mer.unique.nochrM.aligned.rds && rm "$line".mm9.36_4mer.unique.nochrM.aligned.rds.log && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line".mm9.36_4mer.unique.nochrM.3x.2RPM.hts "$line".mm9.36_4mer.unique.nochrM.3x.2RPM.bed -nolabel && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line".mm9.36_4mer.unique.nochrM.5x.4RPM.hts "$line".mm9.36_4mer.unique.nochrM.5x.4RPM.bed -nolabel && " >> testcode
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line".mm9.36mer.unique.nochrM.3x.2RPM.bed /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.nochrM.3x.2RPM.bigBed && " >> testcode
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line".mm9.36mer.unique.nochrM.5x.4RPM.bed /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.nochrM.5x.4RPM.bigBed & " >> testcode
    done <testFolderPath




echo '' >> testcode
echo "******take a break***********" >> testcode
echo "bigWig (Index, SAMstats, idxstats, bedgraph, make5prime, wigToBigwig codes:" >> testcode
echo "*****************" >> testcode

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcode
while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line".mm9.36mer.unique.bam \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line".mm9.36mer.unique.bam "$line".mm9.36mer.SAMstats -bam /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line".mm9.36mer.unique.bam > "$line".mm9.36mer.idxstats\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand + --unique --splice --chromonly --normalize --verbose "$line".mm9.36mer.unique.bam "$line".mm9.36mer.unique.plus.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand - --unique --splice --chromonly --normalize --verbose "$line".mm9.36mer.unique.bam "$line".mm9.36mer.unique.minus.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --unique --splice --chromonly --normalize --verbose "$line".mm9.36mer.unique.bam "$line".mm9.36mer.unique.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line".mm9.36mer.unique.bam  /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.5prime.wig -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line".mm9.36mer.unique.bam  /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.5prime.plus.wig -stranded + -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line".mm9.36mer.unique.bam  /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.5prime.minus.wig -stranded - -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36mer.unique.plus.bg4 /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.plus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36mer.unique.minus.bg4 /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.minus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36mer.unique.bg4 /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36mer.unique.5prime.plus.wig /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.5prime.plus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36mer.unique.5prime.minus.wig /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.5prime.minus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36mer.unique.5prime.wig /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36mer.unique.5prime.bigWig\" & \n" >> testcode

        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line".mm9.36_4mer.unique.bam \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line".mm9.36_4mer.unique.bam "$line".mm9.36_4mer.SAMstats -bam /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line".mm9.36_4mer.unique.bam > "$line".mm9.36_4mer.idxstats\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand + --unique --splice --chromonly --normalize --verbose "$line".mm9.36_4mer.unique.bam "$line".mm9.36_4mer.unique.plus.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand - --unique --splice --chromonly --normalize --verbose "$line".mm9.36_4mer.unique.bam "$line".mm9.36_4mer.unique.minus.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --unique --splice --chromonly --normalize --verbose "$line".mm9.36_4mer.unique.bam "$line".mm9.36_4mer.unique.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line".mm9.36_4mer.unique.bam  /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.5prime.wig -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line".mm9.36_4mer.unique.bam  /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.5prime.plus.wig -stranded + -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line".mm9.36_4mer.unique.bam  /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.5prime.minus.wig -stranded - -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36_4mer.unique.plus.bg4 /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.plus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36_4mer.unique.minus.bg4 /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.minus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36_4mer.unique.bg4 /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36_4mer.unique.5prime.plus.wig /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.5prime.plus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36_4mer.unique.5prime.minus.wig /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.5prime.minus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line".mm9.36_4mer.unique.5prime.wig /woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes "$line".mm9.36_4mer.unique.5prime.bigWig\" & \n" >> testcode
    done <testFolderPath





echo '' >> testcode
echo "Mitochondria-Sex-reports codes:" >> testcode
echo "*****************" >> testcode

printf '''
echo "file chrXYM_reads" > chrXYM_reads
for file in *.idxstats
    do
        chr1_reads=$(egrep -w "chr1|chr1_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr2_reads=$(egrep -w "chr2|chr2_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr3_reads=$(egrep -w "chr3|chr3_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr4_reads=$(egrep -w "chr4|chr4_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr5_reads=$(egrep -w "chr5|chr5_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr6_reads=$(egrep -w "chr6|chr6_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr7_reads=$(egrep -w "chr7|chr7_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr8_reads=$(egrep -w "chr8|chr8_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr9_reads=$(egrep -w "chr9|chr9_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr10_reads=$(egrep -w "chr10|chr10_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr11_reads=$(egrep -w "chr11|chr11_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr12_reads=$(egrep -w "chr12|chr12_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr13_reads=$(egrep -w "chr13|chr13_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr14_reads=$(egrep -w "chr14|chr14_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr15_reads=$(egrep -w "chr15|chr15_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr16_reads=$(egrep -w "chr16|chr16_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr17_reads=$(egrep -w "chr17|chr17_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr18_reads=$(egrep -w "chr18|chr18_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chr19_reads=$(egrep -w "chr19|chr19_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chrX_reads=$(egrep -w "chrX|chrX_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chrY_reads=$(egrep -w "chrY|chrY_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chrM_reads=$(egrep -w "chrM|chrM_random" $file | cut -f3 | awk "{sum+=$1} END {print sum}")
        chrUn_reads=$(egrep -w "chrUn_random" $file | cut -f3)
        chrUnmapped=$(egrep -w '*' $file | cut -f4)
        echo $file $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads $chrUn_reads $chrUnmapped >> chr_reads
    done

''' >> testcode









