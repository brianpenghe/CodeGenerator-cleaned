#!/bin/sh
sed -i 's/23_29/19_30/g' bowtie*
sed -i 's/23_29/19_30/g' testcode*
sed -i 's/23_29/19_30/g' piRNA_PostProcess.sh
sed -i 's/length($2) >= 23 \&\& length($2) <= 29/length($2) >= 19 \&\& length($2) <= 30/g' testcode
sed -i 's/MINLEN:20/MINLEN:19/g' testcode
