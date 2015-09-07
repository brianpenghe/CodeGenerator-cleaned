#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed
#delete the testFolderPath file
#it generates three files: bowtieXXXXXX testcode & testFolderPath
#usage: ./GECmm9CodeGeneratorATAC.sh test mm9

echo '' > testcode
CurrentLo=$(pwd)
if [ "$2" == "mm9" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/mm9.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/mm9"
    chromsizes="/woldlab/castor/home/georgi/genomes/mm9/mm9.chrom.sizes"
elif [ "$2" == "hg19male" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGR+spikes.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGR+spikes"
    chromsizes="/woldlab/castor/home/georgi/genomes/hg19/hg19-male-single-cell-NIST-fixed-spikes.chrom.sizes"
elif [ "$2" == "hg19female" ]
then
    fa="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGS+spikes.fa"
    bowtieindex="/woldlab/castor/proj/genome/bowtie-indexes/ENCFF001RGS+spikes"
    chromsizes="/woldlab/castor/home/georgi/genomes/hg19/hg19-female-single-cell-NIST-fixed-spikes.chrom.sizes"
fi


source /woldlab/castor/home/phe/programs/DownloadFolder.sh $1

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "refolder,unzip and FastQC codes:" >> testcode
echo "********(checkout bowtie condor file)*********" >> testcode
while read line
    do
        Folders=$(echo $line | cut -d' ' -f1 | sed "s/https:\///g" | rev | cut -d '/' -f3- | rev)
        SampleID=$(echo $line | cut -d' ' -f1 | rev | cut -d '/' -f2 | rev)
        SampleMeta=$(echo $line | cut -d' ' -f2- | sed "s/\//_/g" | sed "s/ /_/g")
        OldDataPath=$(echo $CurrentLo$Folders"/"$SampleID)
        path=$(echo $CurrentLo"/"$SampleID$SampleMeta)
        printf "mv "$OldDataPath" "$path" &&\n" >> testcode
        printf $path"\n" >> testFolderPath
        printf "mkdir "$path"FastQCk6 && " >> testcode
        printf "gunzip -c "$path"/*.fastq.gz | python /woldlab/castor/home/georgi/code/trimfastq.py - 36 -stdout > "$path"allfastq && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$path"allfastq -o "$path"FastQCk6 -k 6 & \n" >> testcode
    done <$1

source /woldlab/castor/home/phe/programs/BowtieCodeGenerator.sh testFolderPath $2

echo '' >> testcode
echo "******take a break***********" >> testcode
echo "eRange(chrM-Removal, filtermulti, index, SAMstats, makeRds, findall, regiontobed, bedtobigbed) codes:" >> testcode
echo "*****************" >> testcode


while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2".36mer.unique.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2".36mer.unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2".36mer.unique.nochrM.bam \" && " >> testcode
        printf "condor_run \" python /woldlab/castor/home/georgi/code/filterBAMMulti.py "$line"."$2".36mer.unique.nochrM.bam /woldlab/castor/proj/programs/samtools-0.1.8/samtools 1 "$line"."$2".36mer.unique.nochrM.aligned.bam\" && " >> testcode
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2".36mer.unique.nochrM.aligned.bam \" && rm "$line"."$2".36mer.unique.nochrM.bam && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2".36mer.unique.nochrM.aligned.bam "$line"."$2".36mer.unique.nochrM.aligned.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/erange-4.0a/MakeRdsFromBam5.py reads "$line"."$2".36mer.unique.nochrM.aligned.bam "$line"."$2".36mer.unique.nochrM.aligned.rds --index --cache=20000000\" && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line"."$2".36mer.unique.nochrM.3x.2RPM- "$line"."$2".36mer.unique.nochrM.aligned.rds "$line"."$2".36mer.unique.nochrM.3x.2RPM.hts -minimum 2 -ratio 3 -listPeak -cache 20000000 -nodirectionality && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/findall.py "$line"."$2".36mer.unique.nochrM.5x.4RPM- "$line"."$2".36mer.unique.nochrM.aligned.rds "$line"."$2".36mer.unique.nochrM.5x.4RPM.hts -minimum 4 -ratio 5 -listPeak -cache 20000000 -nodirectionality && rm "$line"."$2".36mer.unique.nochrM.aligned.rds && rm "$line"."$2".36mer.unique.nochrM.aligned.rds.log && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line"."$2".36mer.unique.nochrM.3x.2RPM.hts "$line"."$2".36mer.unique.nochrM.3x.2RPM.bed -nolabel && " >> testcode
        printf "python /woldlab/castor/home/georgi/code/commoncode/regiontobed.py --- "$line"."$2".36mer.unique.nochrM.5x.4RPM.hts "$line"."$2".36mer.unique.nochrM.5x.4RPM.bed -nolabel && " >> testcode
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2".36mer.unique.nochrM.3x.2RPM.bed "$chromsizes" "$line"."$2".36mer.unique.nochrM.3x.2RPM.bigBed && " >> testcode
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2".36mer.unique.nochrM.5x.4RPM.bed "$chromsizes" "$line"."$2".36mer.unique.nochrM.5x.4RPM.bigBed & \n" >> testcode
    done <testFolderPath




echo '' >> testcode
echo "******take a break***********" >> testcode
echo "bigWig (Index, SAMstats, idxstats, bedgraph, make5prime, wigToBigwig codes:" >> testcode
echo "*****************" >> testcode

printf "export PYTHONPATH=/woldlab/castor/home/hamrhein/src/python/packages \n" >> testcode
while read line
    do
        printf "condor_run \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2".36mer.unique.bam \" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/SAMstats.py "$line"."$2".36mer.unique.bam "$line"."$2".36mer.SAMstats -bam "$chromsizes" /woldlab/castor/proj/programs/samtools-0.1.8/samtools \" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$line"."$2".36mer.unique.bam > "$line"."$2".36mer.idxstats\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand + --unique --splice --chromonly --normalize --verbose "$line"."$2".36mer.unique.bam "$line"."$2".36mer.unique.plus.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --strand - --unique --splice --chromonly --normalize --verbose "$line"."$2".36mer.unique.bam "$line"."$2".36mer.unique.minus.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/hamrhein/bin/bamToBedGraph.py --match --unique --splice --chromonly --normalize --verbose "$line"."$2".36mer.unique.bam "$line"."$2".36mer.unique.bg4\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2".36mer.unique.bam  "$chromsizes" "$line"."$2".36mer.unique.5prime.wig -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2".36mer.unique.bam  "$chromsizes" "$line"."$2".36mer.unique.5prime.plus.wig -stranded + -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"python /woldlab/castor/home/georgi/code/make5primeWigglefromBAM-NH.py --- "$line"."$2".36mer.unique.bam  "$chromsizes" "$line"."$2".36mer.unique.5prime.minus.wig -stranded - -notitle -uniqueBAM -RPM\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2".36mer.unique.plus.bg4 "$chromsizes" "$line"."$2".36mer.unique.plus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2".36mer.unique.minus.bg4 "$chromsizes" "$line"."$2".36mer.unique.minus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2".36mer.unique.bg4 "$chromsizes" "$line"."$2".36mer.unique.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2".36mer.unique.5prime.plus.wig "$chromsizes" "$line"."$2".36mer.unique.5prime.plus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2".36mer.unique.5prime.minus.wig "$chromsizes" "$line"."$2".36mer.unique.5prime.minus.bigWig\" && " >> testcode
        printf "condor_run \"/woldlab/castor/proj/genome/programs/x86_64/wigToBigWig "$line"."$2".36mer.unique.5prime.wig "$chromsizes" "$line"."$2".36mer.unique.5prime.bigWig\" & \n" >> testcode
    done <testFolderPath





echo '' >> testcode
echo "Mitochondria-Sex-reports codes:" >> testcode
echo "******************" >> testcode

printf '''
    echo "file chrXYM_reads" > chrXYM_reads
    for file in *.idxstats
        do
''' >> testcode

if [ "$2" == "mm9" ]
then
    for i in {1..19} 'X' 'Y' 'M'
        do
            echo "      chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' \$file | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
        done
        echo "      chrUn_reads=\$(egrep -w 'chrUn_random' \$file | cut -f3)" >> testcode
        echo "      chrUnmapped=\$(egrep -w '*' \$file | cut -f4)" >> testcode
    printf '''
        echo $file $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chrX_reads $chrY_reads $chrM_reads $chrUn_reads $chrUnmapped >> chr_reads
        done
    ''' >> testcode
elif [ "$2" == "hg19male" ]
then
    for i in {1..22} 'X' 'Y' 'M'
        do
            echo "      chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' \$file | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
        done

        echo "      chrUnmapped=\$(egrep -w '*' \$file | cut -f4)" >> testcode
    printf '''
        echo $file $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chr20_reads $chr21_reads $chr22_reads $chrX_reads $chrY_reads $chrM_reads $chrUnmapped >> chr_reads
        done
    ''' >> testcode
elif [ "$2" == "hg19female" ]
then
    for i in {1..22} 'X' 'M'
        do
            echo "      chr"$i"_reads=\$(egrep -w 'chr"$i"|chr"$i"_random' \$file | cut -f3 | awk '{sum+=\$1} END {print sum}')" >> testcode
        done

    echo "      chrUnmapped=\$(egrep -w '*' \$file | cut -f4)" >> testcode
    printf '''
        echo $file $chr1_reads $chr2_reads $chr3_reads $chr4_reads $chr5_reads $chr6_reads $chr7_reads $chr8_reads $chr9_reads $chr10_reads $chr11_reads $chr12_reads $chr13_reads $chr14_reads $chr15_reads $chr16_reads $chr17_reads $chr18_reads $chr19_reads $chr20_reads $chr21_reads $chr22_reads $chrX_reads $chrM_reads $chrUnmapped >> chr_reads
        done
    ''' >> testcode
fi

#for the following part: move the folder to public_html, then copy paste the following codes to run

echo '' >> testcode
echo "These are bigWig tracks:" >> testcode
echo "******************" >> testcode
current_folder_name=$(pwd|rev|cut -d '/' -f1|rev)
for file in *.bigWig
    do
        echo "track type=bigWig name="$file" description="$file" maxHeightPixels=60:32:8 visibility=full color=150,0,150 bigDataUrl=http://woldlab.caltech.edu/~phe/"$current_folder_name"/"$file >> testcode
    done

echo '' >> testcode
echo "These are bigBed tracks:" >> testcode
echo "******************" >> testcode
current_folder_name=$(pwd|rev|cut -d '/' -f1|rev)
for file in *.bigBed
    do
        echo "track type=bigBed name="$file" description="$file" maxHeightPixels=60:32:8 visibility=full color=150,0,150 bigDataUrl=http://woldlab.caltech.edu/~phe/"$current_folder_name"/"$file >> testcode
    done








