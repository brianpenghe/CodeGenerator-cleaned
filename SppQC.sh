#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/SppQC.sh testFolderPath mm9 30mers
#this has to be done after Tophat

echo '' > testcodeSpp
CurrentLo=$(pwd)

echo "#!/bin/bash" >> testcodeSpp
echo "#SppQC codes:" >> testcodeSpp
echo "#*****************" >> testcodeSpp


while read line
    do
        printf "Rscript /woldlab/castor/home/georgi/code/spp/spp_package/run_spp.R -c="$line"."$2"."$3".unique.bam -p=4 -savp -rf -s=-0:2:400 -out="$line"."$2"."$3".unique.QC & \n" >> testcodeSpp
    done <$1

chmod a+x testcodeSpp



