#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/CufflinksCode.sh test mm9 36mer

echo '' >> testcodeCufflinks
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo '' >> testcodeCufflinks
echo "******take a break***********" >> testcodeCufflinks
echo "Cufflinks (Run Cufflinks, sort isoform and gene tables) codes:" >> testcodeCufflinks
echo "*****************" >> testcodeCufflinks

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcodeCufflinks
while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/cufflinks-1.3.0.Linux_x86_64/cufflinks -p 8 --compatible-hits-norm --GTF /woldlab/castor/home/phe/Mus_musculus.NCBIM37.67.filtered.removingENSMUST00000127664.gtf --output-dir "$line"."$2"."$3"Cufflinks1.3.0 \" "$line"."$2"."$3"/accepted_hits.bam && " >> testcodeCufflinks
        printf "condor_run \" sort -k 1d,1 "$line"."$2"."$3"Cufflinks1.3.0/isoforms.fpkm_tracking > "$line"."$2"."$3"Cufflinks1.3.0/isoforms.fpkm_trackingSorted \" && " >> testcodeCufflinks
        printf "awk '{print \$1\$7\"\\\t\"$0}' "$line"."$2"."$3"Cufflinks1.3.0/genes.fpkm_tracking | sort -k 1d,1  > "$line"."$2"."$3"Cufflinks1.3.0/genes.fpkm_trackingSorted & " >> testcodeCufflinks
        printf $line" "$line"."$2"."$3"Cufflinks1.3.0/genes.fpkm_trackingSorted 0,1,5,7 8\n" >> CufflinksgeneFPKMs 
        printf $line" "$line"."$2"."$3"Cufflinks1.3.0/genes.fpkm_trackingSorted 0,1,5,7 9\n" >> CufflinksgeneConflows
        printf $line" "$line"."$2"."$3"Cufflinks1.3.0/isoforms.fpkm_trackingSorted 0,3,4,6,7 9\n" >> CufflinksisoformFPKMs
        printf $line" "$line"."$2"."$3"Cufflinks1.3.0/isoforms.fpkm_trackingSorted 0,3,4,6,7 10\n" >> CufflinksisoformConflows
    done <$1


