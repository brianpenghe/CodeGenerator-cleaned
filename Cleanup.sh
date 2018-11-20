#!/bin/bash
#Run these codes in the current SERVER directory

if [ "$1" == "RNAseq" ]
    then
        rm testcode* testFolderPath testSampleList *.condor HTseqTable index.html Cufflinks*s SampleListGenerator.log tophat2.*.*
elif [ "$1" == "CLIPseq" ]
    then
        rm testcode* testFolderPath testSampleList HTseq*.condor HTseqTable tophat*.condor index.html Cufflinks*s SampleListGenerator.log tophat2.*.* *FastUniqInput		
elif [ "$1" == "ATAC" ]
    then
        rm testcode* testFolderPath testSampleList bowtie*.condor index.html SampleListGenerator.log shell.*.*
elif [ "$1" == "4C" ]
    then
        rm testcode* testFolderPath testSampleList bowtie*.stderr index.html SampleListGenerator.log
else exit "error in project type" 
fi



