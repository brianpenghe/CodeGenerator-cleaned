#!/bin/bash
#SpeciesReporter.sh input
while read line
    do
        printf $line":"
        if [ $(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:species_name" content="' | wc -l) != 0 ]
            then
                wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:species_name" content="' | cut -d\" -f4 
        else
            printf " no species found\n"
        fi
    done <$1

