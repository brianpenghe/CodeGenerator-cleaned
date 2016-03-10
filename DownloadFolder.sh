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

