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


/woldlab/castor/home/phe/programs/TophatCodeGenerator.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/STARCodeGenerator.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/RsemCodeGenerator.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/STARbigWigCoverageCode.sh testFolderPath $2 $3

/woldlab/castor/home/phe/programs/RNAseQC.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TophatbigWigCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/HTseqCodeGenerator.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/CufflinksCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TophatCufflinksStats.sh testFolderPath $2 $3


