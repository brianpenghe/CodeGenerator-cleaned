#!/bin/bash
#Run these codes in the current SERVER directory
#Thie script needs a file named testSampleList
#this file contains links to the data to aggregate and its metadata
#e.g each line can be http://jumpgate.caltech.edu/runfolders/volvox/141121_SN787_0295_BHBE3UADXX/Unaligned/Project_15160_indexN707-N505/Sample_15160/ http://jumpgate.caltech.edu/runfolders/volvox/141110_SN787_0290_AHCCNNADXX/Unaligned/Project_15160_indexN707-N505/Sample_15160/  Sample15160
#usage: ./ENCODEDownloadFolder.sh testSampleList

echo "Curl codes:" >> testcode
echo "****************" >> testcode
while read line
    do
        declare -i k
        k=1
        while [[ $(echo $line | cut -d' ' -f$k | cut -c1-4) == "http" || $(echo $line | cut -d' ' -f$k | cut -c1-3) == "ftp" ]]
            do
                Download=$(echo $line | cut -d' ' -f$k)
				if [[ $(echo $line | cut -d' ' -f$k | cut -c1-4) == "http" ]]
					then
						echo 'sleep 1s; curl -RL -u BUFXRY6P:hv7oczhoda2i6ygz '$Download' -o '$(echo $Download | rev | cut -d/ -f1 | rev) >> testcode
				elif [[ $(echo $line | cut -d' ' -f$k | cut -c1-3) == "ftp" ]]
					then
                        echo 'sleep 1s; curl -RL -u BUFXRY6P:hv7oczhoda2i6ygz '$Download' -o '$(echo $Download | rev | cut -d/ -f1 | rev) >> testcode
				fi
                k=$k+1
            done
    done <$1

