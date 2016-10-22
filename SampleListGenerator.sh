#!/bin/bash
#SampleListGenerator.sh input output
printf '' > $2
printf '' > SampleListGenerator.log

while read line
    do
        printf $line":"
        printf $line":" >> SampleListGenerator.log
        if [ $(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:flowcell" resource="' | wc -l) != 0 ]
            then
                wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:flowcell" resource="' | cut -d/ -f3 > Flowcell
                while read Flow
                    do
                        printf $Flow
                        printf $Flow >> SampleListGenerator.log
                        for database in "/" "02/"
                            do
                                wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox$database -q -O - > index.html
                                grep $Flow index.html | grep -v $Flow"_temp" | cut -d"\"" -f8 > SubFlowcell
                                declare -i FlowN=0
                                for label in "Unaligned/" "Unaligned.dualIndex/" "Unaligned.singleIndex/" "xUnaligned.single_index/" "Unaligned.dual_index/" "Unaligned.PFonly/"
                                    do
                                        while read SubFlow
                                            do
                                                if [ $(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox$database$SubFlow$label -q -O - | grep $line | wc -l) != 0 ]
                                                    then
                                                        wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox$database$SubFlow$label -q -O - | grep $line | cut -d"\"" -f8 > projects
                                                        while read project
                                                            do
                                                                printf "https://jumpgate.caltech.edu/runfolders/volvox"$database$SubFlow$label$project$(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox$database$SubFlow$label$project -q -O - | grep "Sample_"$line | cut -d\" -f8 | cut -d/ -f1 )"/ " >> $2
                                                                if [[ $(wc -l projects | cut -d' ' -f1 ) -gt 1 ]]
                                                                    then
                                                                        printf $(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep libns:name | cut -d"<" -f2 | cut -d">" -f2 | sed -r "s/[/\ %#;&~()]/_/g")$( echo $project | cut -d/ -f1 )"/\n" >> $2
                                                                fi
                                                            done<projects
                                                        printf " got in volvox"$database$SubFlow$label
                                                        printf " got in volvox"$database$SubFlow$label >> SampleListGenerator.log
                                                        FlowN=$FlowN+1
                                                fi
                                            done<SubFlowcell
                                    done
                                if [ $FlowN == 0 ]
                                    then
                                        printf " Not found in volvox"$database
                                        printf " Not found in volvox"$database >> SampleListGenerator.log
                                fi
                            done
                        printf "\n"
                        printf "\n" >> SampleListGenerator.log
                    done<Flowcell
                if [[ $(wc -l projects | cut -d' ' -f1 ) == 1 ]]
                    then
                        wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep libns:name | cut -d"<" -f2 | cut -d">" -f2 | sed -r "s/[/\ %#;&~()]/_/g" >> $2
                fi
        else
            printf " no Flowcells found\n"
            printf " no Flowcells found\n" >> SampleListGenerator.log
        fi
    done <$1
rm Flowcell SubFlowcell
