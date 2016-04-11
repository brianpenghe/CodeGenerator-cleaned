#!/bin/bash
#Run these codes in the current SERVER directory
#the file testFolderPath has the list of file locations


#usage: ~/programs/4CfastqProcessing.sh test mm9 36 Barcodefile 
#Barcodefile should have lines of "barcodename sequence"
echo '' >> testcode4Cprocess
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcode4Cprocess
echo "#*****************" >> testcode4Cprocess

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcode4Cprocess

declare -i k=0
declare -A barcode seq
while read line
	do
		barcode[0,$k]=$(echo $line | cut -d" " -f1)
		seq[0,$k]=$(echo $line | cut -d" " -f2)
		barcode[1,$k]=$(echo $line | cut -d" " -f3)
		seq[1,$k]=$(echo $line | cut -d" " -f4)
		k=$k+1
	done<$4

k=0
while read line
    do
		for j in 0 1
			do
				printf "python ~/programs/fastqDemultiUserBarcode.py "$line"allfastq100 - "${seq[$j,$k]}" | python /woldlab/castor/home/georgi/code/trimfastq.py - "$3" -trim5 "$(expr length ${seq[$j,$k]})" -stdout | /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 -v 2 -k 1 -m 3 -t --sam-nh --best -y --strata -q --sam - 2> bowtie"$(echo $line | rev | cut -d/ -f1 | rev)"allfastq100mer"${barcode[$j,$k]}".stderr | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"."${barcode[$j,$k]}"mer.unique && " >> testcode4Cprocess
				printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"."${barcode[$j,$k]}"mer.unique.bam \" && " >> testcode4Cprocess
				printf "condor_run \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2"."$3"."${barcode[$j,$k]}"mer.unique.bam > "$line"."$2"."$3"."${barcode[$j,$k]}"mer.idxstats\" && " >> testcode4Cprocess
				printf "condor_run \"python /woldlab/castor/home/georgi/code/makewigglefromBAM-NH.py --- "$line"."$2"."$3"."${barcode[$j,$k]}"mer.unique.bam "$chromsizes" "$line"."$2"."$3"."${barcode[$j,$k]}"mer.unique.bg4 -notitle -uniqueBAM -RPM\" && " >> testcode4Cprocess
				printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2"."$3"."${barcode[$j,$k]}"mer.unique.bg4 "$chromsizes" "$line"."$2"."$3"."${barcode[$j,$k]}"mer.unique.bigWig\" & \n" >> testcode4Cprocess	
			done
    done <$1

chmod a+x testcode4Cprocess
