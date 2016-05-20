#!/bin/bash
#Run these codes in the current SERVER directory
#Thie script needs a file named testSampleList
#this file contains links to the data to aggregate and its metadata
#e.g each line can be http://jumpgate.caltech.edu/runfolders/volvox/141121_SN787_0295_BHBE3UADXX/Unaligned/Project_15160_indexN707-N505/Sample_15160/ http://jumpgate.caltech.edu/runfolders/volvox/141110_SN787_0290_AHCCNNADXX/Unaligned/Project_15160_indexN707-N505/Sample_15160/  Sample15160
#usage: ./DownloadFolder.sh test testSampleList

echo "wget codes:" >> testcode
echo "****************" >> testcode
while read line
    do
        declare -i k
        k=1
        while [[ $(echo $line | cut -d' ' -f$k | cut -c1-4) == "http" || $(echo $line | cut -d' ' -f$k | cut -c1-3) == "ftp" ]]
            do
                Download=$(echo $line | cut -d' ' -f$k | sed "s/https:/http:/g")
				if [[ $(echo $line | cut -d' ' -f$k | cut -c1-4) == "http" ]]
					then
						echo 'wget -r --no-parent --no-check-certificate '$Download' ' >> testcode
				elif [[ $(echo $line | cut -d' ' -f$k | cut -c1-3) == "ftp" ]]
					then
						echo 'wget --no-parent --no-check-certificate '$Download' ' >> testcode
				fi
                k=$k+1
            done
    done <$1

