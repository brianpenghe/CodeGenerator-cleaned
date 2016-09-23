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
                                                        project=$(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox$database$SubFlow$label -q -O - | grep $line | cut -d"\"" -f8)
                                                        printf https://jumpgate.caltech.edu/runfolders/volvox$database$SubFlow$label$project"Sample_"$line"/ " >> $2
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
                wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep libns:name | cut -d"<" -f2 | cut -d">" -f2 | sed -r "s/[/\ %#;&~()]/_/g" >> $2
        else
            printf " no Flowcells found\n"
            printf " no Flowcells found\n" >> SampleListGenerator.log
        fi
    done <$1
rm Flowcell SubFlowcell
