#!/bin/bash
#SampleListGenerator.sh
echo -n '' > testLibs 
wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/ -q -O - | grep "?affiliations__id__exact=" | grep -v "?affiliations__id__exact=60&amp" | cut -d= -f3 | cut -d\" -f1 > testIDs
wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/ -q -O - | grep "?affiliations__id__exact=" | grep -v "?affiliations__id__exact=60&amp" | cut -d= -f3 | cut -d\> -f2 | cut -d\( -f1 | sed "s/ /_/g" > testnames
wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/ -q -O - | grep "?affiliations__id__exact=" | grep -v "?affiliations__id__exact=60&amp" | cut -d= -f3 | cut -d\> -f2 | cut -d\( -f2 | cut -d\) -f1 | sed "s/ /_/g" > testPIs


while read line
    do
        ID=$(echo $line | cut -f1)
        wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/?affiliations__id__exact=$ID -q -O - | grep "libns:library_id" | wc -l >> testLibs
    done < testIDs


paste testIDs testnames testPIs testLibs| column -s $'\t' -t | sort -k 1n,1 > IgorCustomers.table

