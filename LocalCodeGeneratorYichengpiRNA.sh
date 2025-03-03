#!/bin/bash
#Run these codes in the current SERVER directory
#it generates three testfiles: testcode, testFolderPath and testSampleList
#usage: ~/programs/LocalCodeGeneratorYichengpiRNA.sh test mm9 36 SE
#but in fact hard trimming won't be performed. See line 15
#the file test has two columns, Full Location Path and name, only one space allowed
#this script enables combining multiple flowcells.

/woldlab/castor/home/phe/programs/Cleanup.sh ATAC

echo '' > testcode
CurrentLo=$(pwd)

source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2
source /woldlab/castor/home/phe/programs/Localrefolder.sh $1 $2 0 $4 23 29

/woldlab/castor/home/phe/programs/BowtieYichengCodeGeneratorsmallRNA.sh testFolderPath $2 23_29 $4

/woldlab/castor/home/phe/programs/BowtieYichengCodeGeneratorsmallRNA.sh testFolderPath $2 21_22 $4

/woldlab/castor/home/phe/programs/bigWigCodePython2on3.sh testFolderPath $2 "23_29mer"

/woldlab/castor/home/phe/programs/bigWigCodePython2on3.sh testFolderPath $2 "21_22mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig
