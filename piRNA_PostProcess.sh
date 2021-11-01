#!/bin/sh
export PYTHONPATH=$PYTHONPATH:/woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/lib/python2.7/site-packages
#bin counts for vector mappings
ls *vectoronly*.bam | rev | cut -d. -f2- | rev > bams
for i in 10 100 1000
  do
    while read bam
      do
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam.bam \
-of bedgraph -bs $i -o $bam.$i.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam.bam \
-of bedgraph -bs $i --samFlagInclude 16 -o $bam.$i.Minus.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam.bam \
-of bedgraph -bs $i --samFlagExclude 16 -o $bam.$i.Plus.bg4
      done<bams
  done

#bin counts for genome region mappings
ls *23_29mer.unique*.bam > bamsgenome
for i in 10 100 1000
  do
    while read bam
      do
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chrX:21392175-21431907 -o $bam.$i.20A.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chrX:21392175-21431907 --samFlagInclude 16 -o $bam.$i.20A.Minus.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chrX:21392175-21431907 --samFlagExclude 16 -o $bam.$i.20A.Plus.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chr2R:2144349-2386719 -o $bam.$i.42A.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chr2R:2144349-2386719 --samFlagInclude 16 -o $bam.$i.42A.Minus.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chr2R:2144349-2386719 --samFlagExclude 16 -o $bam.$i.42A.Plus.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chrX:21505666-21684449 -o $bam.$i.flamenco.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chrX:21505666-21684449 --samFlagInclude 16 -o $bam.$i.flamenco.Minus.bg4
        /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bedgraph -bs $i --region chrX:21505666-21684449 --samFlagExclude 16 -o $bam.$i.flamenco.Plus.bg4
      done<bamsgenome
  done

#chop to retrieve empty bins
for i in 10 100 1000
  do ls *.$i.*bg4 > bg4.$i.list
    while read bg4
      do
        awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bg4 > signal.bed
        bedops --chop $i signal.bed | bedmap --echo --echo-map-score - signal.bed | \
sed -e 's/|/\t/g' > $bg4.chopped.bg4
      done<bg4.$i.list
  done

#ping pong signature of 23-29mers
while read bam
  do
    samtools view -h $bam > $bam.sam
    python2 ~/190428YichengpiRNA/signature_plot/signature.py $bam.sam 23 29 1 29 $bam.pingpong
  done <<<$(ls *23_29mer.{GFP_SV40,UBIG,originalUBIG}.vectoronly.dup.bam)

while read bam
  do
    samtools view -h $bam chr2R:2144349-2386719 > $bam.sam
    python2 ~/190428YichengpiRNA/signature_plot/signature.py $bam.sam 23 29 1 29 $bam.cluster_42AB.pingpong
  done<<<$(ls *.dm6.23_29mer.unique.dup.bam)

while read bam
  do
    samtools view -h $bam chrX:21392175-21431907 > $bam.sam
    python2 ~/190428YichengpiRNA/signature_plot/signature.py $bam.sam 23 29 1 29 $bam.cluster_20A.pingpong
  done<<<$(ls *.dm6.23_29mer.unique.dup.bam)

while read bam
  do
    samtools view -h $bam chrX:21505666-21684449 > $bam.sam
    python2 ~/190428YichengpiRNA/signature_plot/signature.py $bam.sam 23 29 1 29 $bam.cluster_flamenco.pingpong
  done<<<$(ls *.dm6.23_29mer.unique.dup.bam)

#make bigWig

while read bam
  do
    /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bigwig -bs 1 --samFlagInclude 16 -o $bam.1.Minus.bigWig
    /woldlab/castor/proj/genome/programs/deepTools-2.4.2_develop/bin/bamCoverage -b $bam \
-of bigwig -bs 1 --samFlagExclude 16 -o $bam.1.Plus.bigWig
  done<<<$(ls *.dm6.23_29mer.unique.dup.bam)
