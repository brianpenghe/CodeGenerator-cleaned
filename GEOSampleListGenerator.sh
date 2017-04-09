#!/bin/bash
#SampleListGenerator.sh input output
printf '' > $2
printf '' > SampleListGenerator.log
while read line
    do
        printf $line":"
        printf $line":" >> SampleListGenerator.log
        if [ $(sleep 1s; wget --no-check-certificate --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$line -q -O - | grep 'ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByExp/sra' | wc -l) != 0 ]
            then
				metadata=$(sleep 1s; wget --no-check-certificate --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$line -q -O - | grep -A 1 Title | grep justify | cut -d\> -f2 | cut -d\< -f1 | sed -r "s/[/\ #;-&%~]()/_/g")
                SRXlink=$(sleep 1s; wget --no-check-certificate --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$line -q -O - | grep 'ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByExp/sra' | cut -d\" -f4)
				sleep 1s; wget --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" $SRXlink/ -q -O - | grep SRR | cut -d\" -f2 > SRRlinks
                while read SRRlink
                    do
                        SRAlink=$(sleep 1s; wget --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" $SRRlink/ -q -O - | grep .sra\" | cut -d\" -f2)
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
