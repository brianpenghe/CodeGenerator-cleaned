#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed


#usage: ./DEseqRun.sh Gm2694 Gm2694 Control Control Gm2694 Gm11019
printf "It's your own responsibility to make sure your condition keys match/correpsond to the file names"
CurrentLo=$(pwd)
ls *.count > Countlist
vector_len=$(ls *.count | wc -l)
args=("$@")
if [ $vector_len -eq $# ]
then
	echo ""
else
	printf "wrong number of arguments from your input commandline \n"
    exit 1
fi

declare -i j=0
while read line
	do
		echo ${args[${j}]} >> test.HTdict 
		echo $(echo $line | rev | cut -d. -f2- | rev),$line,${args[${j}]} >> HTseqWhole.csv
		j=$j+1
	done < Countlist
	
sort test.HTdict | uniq > test.HTdictuniq
while read key
	do
		if [ "$key" == "Control" ]
		then
			continue
		fi
		echo $key
		echo "sampleName,fileName,condition" > HTseq$key.csv
		echo "sampleName,fileName,condition" > HTseqAll$key.csv
		grep ","$key HTseqWhole.csv >> HTseq$key.csv
		grep ","$key HTseqWhole.csv >> HTseqAll$key.csv
		grep -v ","$key HTseqWhole.csv | awk -F',' '{print $1","$2",Control"}' >> HTseqAll$key.csv
		grep Control HTseqWhole.csv >> HTseq$key.csv
	
		Rscript ~/programs/deseq2.Rscript HTseq$key.csv Control DEseq$key
		Rscript ~/programs/deseq2.Rscript HTseqAll$key.csv Control DEseqAll$key
		awk -F',' '{if ($3 < 0) print $0 }'  DEseq$key | grep -v ",0,NA,NA,NA,NA,NA" | sort -t"," -k 6g,6 > DEseq$key.down
		awk -F',' '{if ($3 > 0) print $0 }'  DEseq$key | grep -v ",0,NA,NA,NA,NA,NA" | sort -t"," -k 6g,6 > DEseq$key.up
		awk -F',' '{if ($3 < 0) print $0 }'  DEseqAll$key | grep -v ",0,NA,NA,NA,NA,NA" | sort -t"," -k 6g,6 > DEseqAll$key.down
		awk -F',' '{if ($3 > 0) print $0 }'  DEseqAll$key | grep -v ",0,NA,NA,NA,NA,NA" | sort -t"," -k 6g,6 > DEseqAll$key.up
	done < test.HTdictuniq
rm test.HTdict test.HTdictuniq HTseqWhole.csv


