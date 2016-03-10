#!/bin/bash
#SampleListGenerator.sh input output
printf '' > $2
printf '' > SampleListGenerator.log
while read line
    do
        printf $line":"
        printf $line":" >> SampleListGenerator.log
        if [ $(wget --no-check-certificate https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$line -q -O - | grep 'ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByExp/sra' | wc -l) != 0 ]
            then
				metadata=$(wget --no-check-certificate https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$line -q -O - | grep -A 1 Title | grep justify | cut -d\> -f2 | cut -d\< -f1)
                SRXlink=$(wget --no-check-certificate https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$line -q -O - | grep 'ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByExp/sra' | cut -d\" -f4)
				SRRlink=$(wget $SRXlink/ -q -O - | grep SRR | cut -d\" -f2)
				SRAlink=$(wget $SRRlink/ -q -O - | grep .sra\" | cut -d\" -f2)
				
				printf $SRAlink" "$metadata"\n" >> $2
				printf " found "$(echo $SRAlink | rev | cut -d. -f2 | rev )"\n"
				printf " found "$(echo $SRAlink | rev | cut -d. -f2 | rev )"\n" >> SampleListGenerator.log
        else
            printf " no sra found "
            printf " no sra found " >> SampleListGenerator.log
        fi
    done <$1

