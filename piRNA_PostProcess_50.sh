#!/bin/bash
#bin counts for vector mappings
Coordinates_20A='chrX:21519548:21560880'
Coordinates_42AB='chr2R:6256844:6499214'
Coordinates_Flam='chrX:21632639:21883809'

ls *vectoronly*.bam | rev | cut -d. -f2- | rev > bams
for i in 10 100 1000
  do
    while read bam
      do
        bamCoverage -b $bam.bam \
-of bedgraph -bs $i -o $bam.$i.bg4
        bamCoverage -b $bam.bam \
-of bedgraph -bs $i --samFlagInclude 16 -o $bam.$i.Minus.bg4
        bamCoverage -b $bam.bam \
-of bedgraph -bs $i --samFlagExclude 16 -o $bam.$i.Plus.bg4
      done<bams
  done

#bin counts for genome region mappings
ls */*merAligned.sortedByCoord.out.bam > bamsgenome
for i in 10 100 1000
  do
    while read bam
      do
        /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index $bam
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_20A -o $bam.$i.20A.bg4
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_20A --samFlagInclude 16 -o $bam.$i.20A.Minus.bg4
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_20A --samFlagExclude 16 -o $bam.$i.20A.Plus.bg4
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_42AB -o $bam.$i.42A.bg4
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_42AB --samFlagInclude 16 -o $bam.$i.42A.Minus.bg4
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_42AB --samFlagExclude 16 -o $bam.$i.42A.Plus.bg4
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_Flam -o $bam.$i.flamenco.bg4
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_Flam --samFlagInclude 16 -o $bam.$i.flamenco.Minus.bg4
        bamCoverage -b $bam \
-of bedgraph -bs $i --region $Coordinates_Flam --samFlagExclude 16 -o $bam.$i.flamenco.Plus.bg4
      done<bamsgenome
  done

#chop to retrieve empty bins
for i in 10 100 1000
  do ls {*.$i.*bg4 *k6/*.$i.*bg4} > bg4.$i.list
    while read bg4
      do
        awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bg4 > signal.bed
        bedops --chop $i signal.bed | bedmap --echo --echo-map-score - signal.bed | \
sed -e 's/|/\t/g' > $bg4.chopped.bg4
      done<bg4.$i.list
  done
