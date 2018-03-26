#!/bin/bash
#so far this script only works for W3110
#the bigWig parts of the codes need manual replacement
#Run these codes in the current SERVER directory
#it generates three testfiles: testcode, testFolderPath and testSampleList
#usage: ~/programs/GECCodeGeneratorShuaiWangRibo.sh test W3110 36
#test file is just a list of library ID(number)s.
#this script enables combining multiple flowcells.

/woldlab/castor/home/phe/programs/Cleanup.sh ATAC
echo '' > testcode
CurrentLo=$(pwd)
/woldlab/castor/home/phe/programs/SampleListGenerator.sh $1 testSampleList
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2
/woldlab/castor/home/phe/programs/DownloadFolder.sh testSampleList
source /woldlab/castor/home/phe/programs/GECrefolderShuaiWangRibo.sh $4 $2 $3

/woldlab/castor/home/phe/programs/bigWigCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TrackSummary.sh bigBed


