#!/bin/bash
#Run these codes in the current SERVER directory
#it generates three testfiles: testcode, testFolderPath and testSampleList
#usage: ~/programs/LocalCodeGeneratorYichengpiRNA.sh test mm9 36 SE #36 is useless
#but in fact hard trimming won't be performed. See line 15
#the file test has two columns, Full Location Path and name, only one space allowed
#this script enables combining multiple flowcells.

/woldlab/castor/home/phe/programs/Cleanup.sh ATAC

echo '' > testcode
CurrentLo=$(pwd)

source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2
source /woldlab/castor/home/phe/programs/Localrefolder.sh $1 $2 0 $4 20 250
/woldlab/castor/home/phe/programs/BowtieCodeGeneratorYichengTotalRNArRNARemoval.sh testFolderPath dm6 20_250 $4

/woldlab/castor/home/phe/programs/TophatCodeGenerator.sh testFolderPath dm6 20_250 $4

/woldlab/castor/home/phe/programs/STARCodeGeneratorYicheng.sh testFolderPath dm6 20_250 $4

/woldlab/castor/home/phe/programs/RsemCodeGenerator.sh testFolderPath dm6 20_250 $4

/woldlab/castor/home/phe/programs/STARbigWigCoverageCode.sh testFolderPath dm6 20_250

/woldlab/castor/home/phe/programs/RNAseQC.sh testFolderPath dm6 20_250"mer"

/woldlab/castor/home/phe/programs/TophatbigWigCode.sh testFolderPath dm6 20_250"mer"

/woldlab/castor/home/phe/programs/HTseqCodeGenerator.sh testFolderPath dm6 20_250 $4

/woldlab/castor/home/phe/programs/CufflinksCode.sh testFolderPath dm6 20_250"mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TophatCufflinksStats.sh testFolderPath dm6 20_250

/woldlab/castor/home/phe/programs/BowtieYichengCodeGeneratorRNA.sh testFolderPath dm6 20_250 $4
