#!/bin/bash
while read bam
    do
        samtools view -h $bam > $bam.sam && \
        python2 ~/190428YichengpiRNA/signature_plot/signature.py $bam.sam 23 29 1 29 $bam.pingpong && \
        rm $bam.sam &
    done<<<$(ls *.DOC.*bam *.Het-A.*bam)

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

for i in 10 100 1000
    do ls *.$i.*bg4 > bg4.$i.list
        while read bg4
            do awk -vOFS="\t" '{ print $1, $2, $3, ".", $4 }' $bg4 > signal.bed
               bedops --chop $i signal.bed | bedmap --echo --echo-map-score - signal.bed \
| sed -e 's/|/\t/g' > $bg4.chopped.bg4
            done<bg4.$i.list
    done
