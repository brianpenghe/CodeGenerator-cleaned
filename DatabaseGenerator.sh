#!/bin/bash
#SampleListGenerator.sh
echo -n '' > testLibs 
wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/ -q -O - | grep "?affiliations__id__exact=" | grep -v "?affiliations__id__exact=60&amp" | cut -d= -f3 | cut -d\" -f1 > testIDs
wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/ -q -O - | grep "?affiliations__id__exact=" | grep -v "?affiliations__id__exact=60&amp" | cut -d= -f3 | cut -d\> -f2 | cut -d\( -f1 | sed "s/ /_/g" > testnames
wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/ -q -O - | grep "?affiliations__id__exact=" | grep -v "?affiliations__id__exact=60&amp" | cut -d= -f3 | cut -d\> -f2 | cut -d\( -f2 | cut -d\) -f1 | sed "s/ /_/g" > testPIs


while read line
    do
        ID=$(echo $line | cut -f1)
        wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/?affiliations__id__exact=$ID -q -O - | grep "libraries" | grep -v "libraries)" | grep -v "span" | cut -d ' ' -f1 >> testLibs
        if [ $(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/?affiliations__id__exact=$ID -q -O - | grep "libraries" | grep -v "libraries)" | grep -v "span" | wc -l) != 1 ]
            then
                echo $ID
        fi
    done < testIDs


paste testIDs testnames testPIs testLibs | column -s $'\t' -t | sed "s/\<\/a//g" | sed  "s/Angela_Stathopoulos/Stathopoulos/g" | sed  "s/Ariel_Chen/Aravin/g" | sed  "s/Alexei_Aravin/Aravin/g" | sed  "s/Barbara_Wold/Wold/g" | sed  "s/Bruce_Hay/Hay/g" | sed  "s/David_Chan/Chan/g" | sed  "s/Elliot_Meyerowitz/Meyerowitz/g" | sed  "s/Ellen_Rothenberg/Rothenberg/g" | sed  "s/Eric_Davidson/Davidson/g" | sed  "s/Miao_Cui/Davidson/g" | sed  "s/John_Allman/Allman/g" | sed  "s/Nancy_Speck/Speck/g" | sed  "s/Pamela_Bjorkman/Bjorkman/g" | sed  "s/Paul_Sternberg/Sternberg/g" | sed  "s/Sarkis_Mazmanian/Mazmanian/g" | sed  "s/Victoria_Orphan/Orphan/g" | sort -k 1n,1 > IgorCustomers.table