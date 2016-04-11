#!/bin/bash
#Run these codes in the current SERVER directory
#usage: ~/programs/GECCodeGenerator4C.sh test mm9 36 Barcodefile
#the sequences are barcodes (primer + restriction site)
#it assumes the reads to be single-ended
#test file is just a list of library ID(number)s.
#this script enables combining multiple flowcells.

/woldlab/castor/home/phe/programs/Cleanup.sh ATAC
echo '' > testcode
CurrentLo=$(pwd)
/woldlab/castor/home/phe/programs/SampleListGenerator.sh $1 testSampleList
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2
/woldlab/castor/home/phe/programs/DownloadFolder.sh testSampleList
source /woldlab/castor/home/phe/programs/GECrefolder.sh SE $2 100

/woldlab/castor/home/phe/programs/4CfastqProcessing.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TrackSummary.sh bigBed



