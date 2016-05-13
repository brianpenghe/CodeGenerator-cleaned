#!/bin/bash
#Run these codes in the current SERVER directory
#the files must be fastq files, no compressed forms allowed
#the file $test has two columns, Current Location Path(end with a backslash) and name, only one space allowed
#each experiment folder contains a set of unzipped fastq files belonging to the same library
#delete the testFolderPath file
#it generates three files: bowtieXXXXXX testcode & testFolderPath
#usage: ~/programs/GECCodeGeneratorATAC.sh test mm9 34 PE
#34 is the full length of the reads

/woldlab/castor/home/phe/programs/Cleanup.sh CLIPseq
echo '' > testcode
CurrentLo=$(pwd)
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2

source /woldlab/castor/home/phe/programs/LocalrefolderCLIP.sh $1 $2 $3 $4

/woldlab/castor/home/phe/programs/TophatCodeGenerator.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/RNAseQC.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TophatbigWigCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/HTseqCodeGenerator.sh testFolderPath $2 $3 $4

/woldlab/castor/home/phe/programs/CufflinksCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TophatCufflinksStats.sh testFolderPath $2 $3


