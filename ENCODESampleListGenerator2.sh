#!/bin/bash
#ENCODESampleListGenerator2.sh "fastq" "https://www.encodeproject.org/search/?searchTerm=p300&type=Experiment&assembly=mm10&biosample_type=tissue&organ_slims=liver&replicates.library.biosample.life_stage=postnatal&replicates.library.biosample.life_stage=embryonic"
#advanced version of ENCODESampleListGenerator.sh
#"fastq" can be replaced by "fold"
source /woldlab/castor/home/phe/programs/NovelCharacterDefinition.sh

wget --no-check-certificate --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" --user=BUFXRY6P --password=hv7oczhoda2i6ygz $2 -q -O - | tr , '\n' | tr '\>' '\n' | grep clearfix | rev | cut -d\$ -f1 | rev | cut -d. -f1 > ENCODE.experiments

echo '' > ENCODE.fastqs
echo '' > ENCODE.meta
echo '' > ENCODE.foldchange

while read line
    do
        echo $line
        curl -RL -u BUFXRY6P:hv7oczhoda2i6ygz "https://www.encodeproject.org$line/?format=json" > JsonString
        paste <(jq '.files[].href' JsonString) <(jq '.files[].accession' JsonString) <(jq '.files[].output_type' JsonString) <(jq '.files[].biological_replicates' JsonString | paste -s | sed -e 's/\]/\n/g' | sed -e 's/[\t\[ ]//g') <(jq '.files[].status' JsonString) > JsonTable
        wget --no-check-certificate --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36" --user=BUFXRY6P --password=hv7oczhoda2i6ygz https://www.encodeproject.org$line -q -O - | tr , '\n' | tr '\<' '\n' | grep "\"summary\":" | rev | cut -d\" -f2 | rev | sed -r "$ReplaceNovel" >> ENCODE.meta
        
        if [ "$1" == "fastq" ]
        then
            grep fastq.gz JsonTable | sed -e 's/\"//g' | awk '{print "https://www.encodeproject"$1}' >> ENCODE.fastqs
        elif [ "$1" == "fold" ]
        then
            grep "fold change" JsonTable | sed -e 's/\"//g' | grep "1,2" | grep "released" | awk '{print "https://www.encodeproject"$1}' >> ENCODE.foldchange
        fi
    done <ENCODE.experiments