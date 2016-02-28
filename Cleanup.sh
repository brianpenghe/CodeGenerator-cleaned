#!/bin/bash
#Run these codes in the current SERVER directory

if [ "$1" == "RNAseq" ]
    then
        rm testcode* testFolderPath testSampleList HTseq*.condor tophat*.condor index.html Cufflinks*s SampleListGenerator.log tophat2.*.*
elif [ "$1" == "ATAC" ]
    then
        rm testcode* testFolderPath testSampleList bowtie*.condor index.html SampleListGenerator.log shell.*.*
else exit "error in project type" 
fi



