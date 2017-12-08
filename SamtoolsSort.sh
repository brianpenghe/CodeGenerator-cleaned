#!/bin/bash
#usage: ./SamtoolsSort.sh bamfile

/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort $1 $(echo $1 | rev | cut -d. -f2- | rev).sorted &&
        /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index $(echo $1 | rev | cut -d. -f2- | rev).sorted.bam &
