#!/bin/bash
#Run these codes in the current SERVER directory
printf "#for the following part: move the folder to public_html, then copy paste the following codes to run" >> testcode
if [ "$1" == "bigBed" ]
then
visibility="pack"
elif [ "$1" == "bigWig" ]
then
visibility="full"
else exit "error in track type" 
fi

echo '' >> testcode
echo "These are $1 tracks:" >> testcode
echo "******************" >> testcode
printf "current_folder_name=\$(pwd|rev|cut -d '/' -f1|rev)" >> testcode


printf '''
    for file in *.'$1'
        do
            echo "track type='$1' name="$file" description="$file" maxHeightPixels=60:32:8 visibility='$visibility' color=150,0,150 bigDataUrl=http://woldlab.caltech.edu/~phe/"$current_folder_name"/"$file >> tracksummary
        done
    ''' >> testcode




