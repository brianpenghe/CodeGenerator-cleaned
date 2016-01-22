#!/bin/bash
#Run these codes in the current SERVER directory
#it generates three testfiles: testcode, testFolderPath and testSampleList
#usage: ~/programs/GECCodeGeneratorATAC.sh test mm9 36
#test file is just a list of library ID(number)s.
#this script enables combining multiple flowcells.

echo '' > testcode
CurrentLo=$(pwd)
/woldlab/castor/home/phe/programs/SampleListGenerator.sh $1 testSampleList
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2
/woldlab/castor/home/phe/programs/DownloadFolder.sh testSampleList
source /woldlab/castor/home/phe/programs/GECrefolder.sh $4

/woldlab/castor/home/phe/programs/BowtieCodeGenerator.sh testFolderPath $2 $3

/woldlab/castor/home/phe/programs/eRangeCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/HOMERCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/bigWigCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/FseqCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TrackSummary.sh bigBed

/woldlab/castor/home/phe/programs/Stats.sh testFolderPath $2 $3


