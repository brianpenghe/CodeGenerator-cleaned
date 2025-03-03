#!/bin/bash
#Run these codes in the current SERVER directory
#it generates three testfiles: testcode, testFolderPath and testSampleList
#usage: ~/programs/GECCodeGeneratorRNAseq.sh test mm9 36 PE
#test file is just a list of library ID(number)s.
#this script enables combining multiple flowcells.

/woldlab/castor/home/phe/programs/Cleanup.sh RNAseq
echo '' > testcode
CurrentLo=$(pwd)
/woldlab/castor/home/phe/programs/SampleListGenerator.sh $1 testSampleList
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2
/woldlab/castor/home/phe/programs/DownloadFolder.sh testSampleList
source /woldlab/castor/home/phe/programs/GECrefolder.sh $4 $2 $3

/woldlab/castor/home/phe/programs/BowtieCodeGeneratorYichengTotalRNArRNARemoval.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/STARCodeGeneratorYicheng.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/STARbigWigCoverageCodeYicheng.sh testFolderPath $2 $3

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig



