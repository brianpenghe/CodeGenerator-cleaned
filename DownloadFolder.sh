#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed
#usage: ./GECmm9CodeGeneratorATAC.sh test
echo '' > testcode
echo "wget codes:" >> testcode
echo "****************" >> testcode
CurrentLo=$(pwd)
while read line
    do
        Download=$(echo $line | cut -d' ' -f1 | sed "s/https:/http:/g")
        echo 'wget -r --no-parent --no-check-certificate '$Download' ' >> testcode
    done <$1

