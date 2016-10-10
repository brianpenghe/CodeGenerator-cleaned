#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed


#usage: ./tophatCodeGenerator.sh testFolderPath mm9 30mer PE
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2
echo '' >> testcodeTophatunmapped
echo "#!/bin/bash" >> testcodeTophatunmapped
echo "#Tophatunmapped code (run bowtie and get .bg4 files)" >> testcodeTophatunmapped

tophatdate=$(date +"%y%m%d")
printf '''
universe=vanilla

environment = "PATH=/bin:/usr/bin:/usr/local/bin:/woldlab/castor/proj/genome/programs/bowtie-0.12.9:/woldlab/castor/proj/genome/programs/tophat-2.0.13.Linux_x86_64"

getenv = true

executable=/usr/bin/python

log=tophat2.$(Process).log
output=tophat2.$(Process).out
error=tophat2.$(Process).err

request_cpus = 4
request_memory = 9000
request_disk = 0

Requirements = (Machine == "pongo.cacr.caltech.edu" || Machine == "myogenin.cacr.caltech.edu" || Machine == "mondom.cacr.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.cacr.caltech.edu")

''' >> tophat$tophatdate.condor


while read path
    do
		printf "/woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools sort -n "$path"."$2"."$3"mer/unmapped.bam "$path"."$2"."$3"mer/unmappedsorted && " >> testcodeTophatunmapped
		printf "/woldlab/castor/proj/genome/programs/tophat-2.0.13.Linux_x86_64/bam2fastx --fastq -o "$path"."$2"."$3"mer/unmapped.fastq -Q -N "$path"."$2"."$3"mer/unmappedsorted.bam &&" >> testcodeTophatunmapped
        if [[ "$4" == "PE" ]]
            then
                printf "arguments=/woldlab/castor/proj/genome/programs/tophat-2.0.13.Linux_x86_64/tophat --bowtie1 -p 4 --no-mixed --GTF  /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered.gtf --transcriptome-index  /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered -o "$path"."$2"."$3"mer /woldlab/castor/home/georgi/genomes/mm9/bowtie-indexes/mm9-single-cell-NIST-fixed-spikes "$path"R1allfastq"$3" "$path"R2allfastq"$3" \nqueue\n" >> tophat$tophatdate".condor"
                printf "python ~/programs/unpoolPairedEnd.py "$path"."$2"."$3"mer/unmapped.fastq && " >> testcodeTophatunmapped
                printf "/woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie ~/genomes/plasmids/bowtie1-index/PatrickCRISPR -p 8 -v 2 -k 1 -t --sam-nh --best -y -q --sam -1 "$path"."$2"."$3"mer/unmapped.fastq1.fastq -2 "$path"."$2"."$3"mer/unmapped.fastq2.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -f 3 -bT ~/genomes/plasmids/PatrickCRISPR.fa - | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools sort - "$path"."$2"."$3"mer/unmapped.Patrick && " >> testcodeTophatunmapped
        elif [[ "$4" == "SE" ]]
            then
                printf "arguments=/woldlab/castor/proj/genome/programs/tophat-2.0.13.Linux_x86_64/tophat --bowtie1 -p 4 --no-mixed --GTF  /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered.gtf --transcriptome-index  /woldlab/castor/proj/genome/transcriptome-indexes/Mus_musculus.NCBIM37.67.filtered -o "$path"."$2"."$3"mer /woldlab/castor/home/georgi/genomes/mm9/bowtie-indexes/mm9-single-cell-NIST-fixed-spikes "$path"allfastq"$3" \nqueue\n" >> tophat$tophatdate".condor"
                printf "/woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie ~/genomes/plasmids/bowtie1-index/PatrickCRISPR -p 8 -v 2 -k 1 -t --sam-nh --best -y -q --sam "$path"."$2"."$3"mer/unmapped.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -F 4 -bT ~/genomes/plasmids/PatrickCRISPR.fa - | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools sort - "$path"."$2"."$3"mer/unmapped.Patrick && " >> testcodeTophatunmapped
        fi
        printf "/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$path"."$2"."$3"mer/unmapped.Patrick.bam && " >> testcodeTophatunmapped
        printf "/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools idxstats "$path"."$2"."$3"mer/unmapped.Patrick.bam > "$path"."$2"."$3"mer/unmapped.Patrick.idxstats && " >> testcodeTophatunmapped
        printf "python /woldlab/castor/home/georgi/code/makewigglefromBAM-NH.py --- "$path"."$2"."$3"mer/unmapped.Patrick.bam ~/genomes/plasmids/bowtie1-index/PatrickCRISPR.chrom.sizes "$path"."$2"."$3"mer.unmapped.Patrick.bg4 -notitle -uniqueBAM -RPM & \n " >> testcodeTophatunmapped
    done <$1

chmod a+rwx testcodeTophatunmapped
