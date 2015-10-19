#!/bin/bash
#SampleListGenerator.sh input output
printf '' > $2
wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox/ -q -O - > index.html
while read line
    do
        printf $line":"
        if [ $(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:flowcell" resource="' | wc -l) != 0 ]
            then
                wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:flowcell" resource="' | cut -d/ -f3 > Flowcell
                while read Flow
                    do
                        printf $Flow
                        declare -i FlowN=0
                        folder=$(grep $Flow index.html | grep -v $Flow"_temp" | cut -d"\"" -f8)
                        for label in "Unaligned/" "Unaligned.dualIndex/" "Unaligned.singleIndex/"
                            do
                                if [ $(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox/$folder$label -q -O - | grep $line | wc -l) != 0 ]
                                    then
                                        project=$(echo $Flowcount | cut -d"\"" -f8)
                                        printf https://jumpgate.caltech.edu/runfolders/volvox/$folder$label$project"Sample_"$line"/ " >> $2
                                        printf " got in "$label
                                        FlowN=$FlowN+1
                                fi
                            done
                        if [ $FlowN == 0 ]
                            then
                                printf " Not found"
                        fi
                        printf "\n"

                    done<Flowcell
                wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep libns:name | cut -d"<" -f2 | cut -d">" -f2 >> $2
        else
            printf " no Flowcells found\n"
        fi
    done <$1
rm Flowcell