#!/bin/bash
#Run these codes in the current SERVER directory
#it generates three testfiles: testcode, testFolderPath and testSampleList
#usage: ~/programs/GECCodeGeneratorYichengpiRNA.sh test mm9 36 SE
#but in fact hard trimming won't be performed. See line 15
#test file is just a list of library ID(number)s.
#this script enables combining multiple flowcells.

/woldlab/castor/home/phe/programs/Cleanup.sh ATAC

echo '' > testcode
CurrentLo=$(pwd)
/woldlab/castor/home/phe/programs/SampleListGenerator.sh $1 testSampleList
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2
/woldlab/castor/home/phe/programs/DownloadFolder.sh testSampleList
source /woldlab/castor/home/phe/programs/GECrefolder.sh $4 $2 0 23 29

/woldlab/castor/home/phe/programs/BowtieYichengCodeGeneratorsmallRNA.sh testFolderPath $2 23_29 $4

/woldlab/castor/home/phe/programs/BowtieYichengCodeGeneratorsmallRNA.sh testFolderPath $2 21_21 $4

/woldlab/castor/home/phe/programs/bigWigCode.sh testFolderPath $2 "23_29mer"

/woldlab/castor/home/phe/programs/bigWigCode.sh testFolderPath $2 "21_21mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig
