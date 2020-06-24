#!/bin/bash
#QuickBowtie.sh CAAACTCATCAATGTATCTTATCATGTCTGGATCGCGGCCGCTTACTTGTACAGCTCGTCCATGCCGAGAGTGATCCCGGCGGCGGTCACGAACTCCAGC Sample_index15_20A_minus_piRNA_1st.fastq
rm templibrary*
/woldlab/castor/proj/genome/programs/bowtie-0.12.7/bowtie-build -c $1 templibrary
/woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie templibrary -p 8 --chunkmbs 1024 -v 0 -a -m 1 -t --sam-nh \
--best --strata -q --sam $2 --al $2.mapped.fastq > $2.tempoutput
