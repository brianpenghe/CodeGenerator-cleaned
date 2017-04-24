#!/bin/bash
#ENCODESampleListGenerator.sh "https://www.encodeproject.org/search/?searchTerm=p300&type=Experiment&assembly=mm10&biosample_type=tissue&organ_slims=liver&replicates.library.biosample.life_stage=postnatal&replicates.library.biosample.life_stage=embryonic"
source /woldlab/castor/home/phe/programs/NovelCharacterDefinition.sh

wget --no-check-certificate --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" --user=BUFXRY6P --password=hv7oczhoda2i6ygz $1 -q -O - | tr , '\n' | tr '\>' '\n' | grep clearfix | rev | cut -d\$ -f1 | rev | cut -d. -f1 > ENCODE.experiments

echo '' > ENCODE.fastqs
echo '' > ENCODE.meta

while read line
    do
        echo $line
        wget --no-check-certificate --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" --user=BUFXRY6P --password=hv7oczhoda2i6ygz https://www.encodeproject.org$line -q -O - | tr , '\n' | grep fastq.gz | grep -v submitted_file_name | rev | cut -d\" -f2 | rev | awk '{print "https://www.encodeproject.org"$1}'>> ENCODE.fastqs
        wget --no-check-certificate --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" --user=BUFXRY6P --password=hv7oczhoda2i6ygz https://www.encodeproject.org$line -q -O - | tr , '\n' | tr '\<' '\n' | grep "\"summary\":" | rev | cut -d\" -f2 | rev | sed -r "$ReplaceNovel" >> ENCODE.meta
    done <ENCODE.experiments