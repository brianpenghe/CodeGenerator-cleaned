#!/bin/bash
#SpeciesReporter.sh input
source /woldlab/castor/home/phe/programs/GECjumpgatePasswords.sh
while read line
    do
        printf $line":"
        if [ $(wget --user=$USER --password="$PSWD" --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:species_name" content="' | wc -l) != 0 ]
            then
                wget --user=$USER --password="$PSWD" --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:species_name" content="' | cut -d\" -f4 
        else
            printf " no species found\n"
        fi
    done <$1

