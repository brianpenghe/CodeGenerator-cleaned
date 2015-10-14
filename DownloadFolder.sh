#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed
#usage: ./DownloadFolder.sh test

echo "wget codes:" >> testcode
echo "****************" >> testcode
while read line
    do
        declare -i k
        k=1
        while [[ $(echo $line | cut -d' ' -f$k | cut -c1-4) == "http" ]]
            do
                Download=$(echo $line | cut -d' ' -f1 | sed "s/https:/http:/g")
                echo 'wget -r --no-parent --no-check-certificate '$Download' ' >> testcode
                k=$k+1
            done
    done <$1

