#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/CufflinksCode.sh test mm9 36mer

echo '' >> testcodeCufflinks
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeCufflinks
echo "#Cufflinks (Run Cufflinks, sort isoform and gene tables) codes:" >> testcodeCufflinks
echo "#*****************" >> testcodeCufflinks

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcodeCufflinks
while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/cufflinks-2.2.1.Linux_x86_64/cufflinks -p 8 -q --no-update-check --max-bundle-length 4500000 --compatible-hits-norm --GTF /woldlab/castor/home/phe/genomes/mm9/Mus_musculus.NCBIM37.67.filtered.removingENSMUST00000127664.gtf --output-dir "$line"."$2"."$3"Cufflinks2.2.1 "$line"."$2"."$3"/accepted_hits.bam 2> "$line"."$2"."$3"Cufflinks.err \" && " >> testcodeCufflinks
        printf "condor_run \" sort -k 1d,1 "$line"."$2"."$3"Cufflinks2.2.1/isoforms.fpkm_tracking > "$line"."$2"."$3"Cufflinks2.2.1/isoforms.fpkm_trackingSorted \" && " >> testcodeCufflinks
        printf "awk '{print \$1\$7\"\\\t\"\$0}' "$line"."$2"."$3"Cufflinks2.2.1/genes.fpkm_tracking | sort -k 1d,1  > "$line"."$2"."$3"Cufflinks2.2.1/genes.fpkm_trackingSorted & \n" >> testcodeCufflinks
        printf $(echo $line | rev | cut -d/ -f1 | rev)"\t"$line"."$2"."$3"Cufflinks2.2.1/genes.fpkm_trackingSorted\t0,1,5,7\t10\n" >> CufflinksgeneFPKMs 
        printf $(echo $line | rev | cut -d/ -f1 | rev)"\t"$line"."$2"."$3"Cufflinks2.2.1/genes.fpkm_trackingSorted\t0,1,5,7\t11\n" >> CufflinksgeneConflows
        printf $(echo $line | rev | cut -d/ -f1 | rev)"\t"$line"."$2"."$3"Cufflinks2.2.1/isoforms.fpkm_trackingSorted\t0,3,4,6,7\t9\n" >> CufflinksisoformFPKMs
        printf $(echo $line | rev | cut -d/ -f1 | rev)"\t"$line"."$2"."$3"Cufflinks2.2.1/isoforms.fpkm_trackingSorted\t0,3,4,6,7\t10\n" >> CufflinksisoformConflows
    done <$1

chmod a+x testcodeCufflinks
