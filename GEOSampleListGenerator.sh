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
				wget $SRXlink/ -q -O - | grep SRR | cut -d\" -f2 > SRRlinks
                while read SRRlink
                    do
                        SRAlink=$(wget $SRRlink/ -q -O - | grep .sra\" | cut -d\" -f2)
                        printf $SRAlink" " >> $2
                        printf " found "$(echo $SRAlink | rev | cut -d/ -f1 | rev )" "
                        printf " found "$(echo $SRAlink | rev | cut -d/ -f1 | rev )" " >> SampleListGenerator.log
                    done <SRRlinks
                printf "\n"
                printf "\n" >> SampleListGenerator.log
                printf $line"_"$metadata"\n" >> $2
                rm SRRlinks
        else
            printf " no sra found "
            printf " no sra found " >> SampleListGenerator.log
        fi
    done <$1

