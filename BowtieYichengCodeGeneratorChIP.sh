#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed
#Two stages: mapping to dm3 first then mapping to vectors
#usage: ./bowtieCodeGenerator.sh testFolderPath dm3 23_29
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2
plasmids=( '42AB_UASG' '42AB_UBIG' '66A_UASG' '66A_UBIG' 'ACTIN-G' 'GFP_SV40' \
'HSP70-G' \
#'Pld_42AB_Jing_ACTIN-G_anti-sense' 'Pld_42AB_Jing_ACTIN-G_sense' \
#'Pld_42AB_Jing_HSP70-G_anti-sense' 'Pld_42AB_Jing_HSP70-G_sense'  'Pld_42AB_Jing_UASG' \
#'Pld_42AB_Jing_UBIG_antisense' 'Pld_42AB_Jing_UBIG'
'UBIG' 'Ubi_promoter_only' \
'originalUBIG' 'drorep' 'MIMIC' 'Circe2kbProGFP' 'Circe2kbProGFPpUbimCherry')

echo "#!/bin/bash" >> testcodePostBowtie
echo "#!/bin/bash" >> testcodePostBowtie2
echo "#bigWig (Index, SAMstats, idxstats) codes:" >> testcodePostBowtie
echo "#bigWig (Index, SAMstats, idxstats) codes:" >> testcodePostBowtie2

bowtiedate=$(date +"%y%m%d.%H.%M.%S.%N")
printf '''
universe=vanilla

executable=/bin/sh

request_cpus = 8
request_memory = 4000
request_disk = 0

Requirements = (Machine == "pongo.caltech.edu" || Machine == "myogenin.caltech.edu" || Machine == "mondom.caltech.edu" || Machine == "trog.caltech.edu" || Machine == "wold-clst-3.woldlab" || Machine == "wold-clst-4.woldlab" || Machine == "myostatin.caltech.edu")

''' | tee bowtie$bowtiedate".condor" bowtie$bowtiedate".2.condor"
echo "log=shell.$bowtiedate.\$(Process).log" >> bowtie$bowtiedate".condor"
echo "log=shell2.$bowtiedate.\$(Process).log" >> bowtie$bowtiedate".2.condor"
echo "output=shell.$bowtiedate.\$(Process).out" >> bowtie$bowtiedate".condor"
echo "output=shell2.$bowtiedate.\$(Process).out" >> bowtie$bowtiedate".2.condor"
echo "error=shell.$bowtiedate.\$(Process).err" >> bowtie$bowtiedate".condor"
echo "error=shell2.$bowtiedate.\$(Process).err" >> bowtie$bowtiedate".2.condor"

while read line
    do
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.dup.bam \" && " >> testcodePostBowtie
		printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view "$line"."$2"."$3"mer.unique.dup.bam | egrep -v chrM | /woldlab/castor/proj/programs/samtools-0.1.8/samtools view -bT "$fa" - -o "$line"."$2"."$3"mer.unique.dup.nochrM.bam \" && " >> testcodePostBowtie
		printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.dup.nochrM.bam \" && " >> testcodePostBowtie
        if [[ "$4" == "PE" ]]
            then
                echo -n ""
#                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"R1allfastq"$3" -2 "$line"R2allfastq"$3" --al "$line"."$2"."$3"mer.unique.fastq --un "$line"."$2"."$3"_unmapped.fastq --max "$line"."$2"."$3"_multi.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
#              printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools rmdup "$line"."$2"."$3"mer.unique.dup.nochrM.bam "$line"."$2"."$3"mer.unique.nochrM.bam \" && " >> testcodePostBowtie
#              printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UASG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"."$2"."$3"_unmapped_1.fastq -2 "$line"."$2"."$3"_unmapped_2.fastq --al "$line"."$2"."$3"mer.42AB_UASG.unique.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UASG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.42AB_UASG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
#               printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UBIG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"."$2"."$3"_unmapped_1.fastq -2 "$line"."$2"."$3"_unmapped_2.fastq --al "$line"."$2"."$3"mer.42AB_UBIG.unique.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/42AB_UBIG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.42AB_UBIG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
#              printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UASG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"."$2"."$3"_unmapped_1.fastq -2 "$line"."$2"."$3"_unmapped_2.fastq --al "$line"."$2"."$3"mer.66A_UASG.unique.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UASG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.66A_UASG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
#              printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UBIG -p 8 --chunkmbs 1024 -v 0 -a -m 1 -X 2000 -t --sam-nh --best --strata -q --sam -1 "$line"."$2"."$3"_unmapped_1.fastq -2 "$line"."$2"."$3"_unmapped_2.fastq --al "$line"."$2"."$3"mer.66A_UBIG.unique.fastq | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/66A_UBIG.fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.66A_UBIG.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
        elif [[ "$4" == "SE" ]]
            then
                printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie "$bowtieindex" -p 8 -v 2 -k 1 -m 1 -t --sam-nh --best -y --strata -q --sam "$line"allfastq"$3" | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -F 4 -bT  "$fa" - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer.unique.dup \' \"\nqueue\n" >> bowtie$bowtiedate".condor"
                printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools rmdup -s "$line"."$2"."$3"mer.unique.dup.nochrM.bam "$line"."$2"."$3"mer.unique.nochrM.bam \" && " >> testcodePostBowtie
                for plasmid in "${plasmids[@]}"
                    do
                        printf "arguments=\"-c \' /woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie /woldlab/loxcyc/home/phe/genomes/YichengVectors/"$plasmid" -p 8 -v 2 -k 1 -m 1 -t --sam-nh --best -y --strata -q --sam "$line"allfastq"$3" | /woldlab/castor/proj/genome/programs/samtools-0.1.8/samtools view -F 4 -bT /woldlab/loxcyc/home/phe/genomes/YichengVectors/"$plasmid".fa - | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools sort - "$line"."$2"."$3"mer."$plasmid".vectoronly.dup \' \"\nqueue\n" >> bowtie$bowtiedate".2.condor"
                    done
        fi
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer.unique.nochrM.bam \" & \n " >> testcodePostBowtie
        for plasmid in "${plasmids[@]}"
            do
                printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools index "$line"."$2"."$3"mer."$plasmid".vectoronly.dup.bam \" && " >> testcodePostBowtie2
            done
        printf "echo $line & \n " >> testcodePostBowtie2
    done <$1


declare -i j=0

echo -n '' > testcodePostBowtieStat$bowtiedate
printf 'echo "sample file total mapped failed multi" > stats1 \n' >> testcodePostBowtieStat$bowtiedate
printf 'echo "sample plasmid total mapped failed multi" > stats2 \n' >> testcodePostBowtieStat$bowtiedate
while read line
    do
      printf '
echo '$line' shell.'$bowtiedate'.'$j'.err \
    $(cat shell.'$bowtiedate'.'$j'.err | grep processed - | cut -d: -f2) \
    $(cat shell.'$bowtiedate'.'$j'.err | grep least - | cut -d: -f2) \
    $(cat shell.'$bowtiedate'.'$j'.err | grep failed - | cut -d: -f2) \
    $(cat shell.'$bowtiedate'.'$j'.err | grep suppressed - | cut -d: -f2) >> stats1
      ' >> testcodePostBowtieStat$bowtiedate

      p_length=${#plasmids[@]}
      for i in ${!plasmids[@]}
        do
          k=$(( j * p_length + i ))
          printf '
echo '$line' '${plasmids[i]}' shell2.'$bowtiedate'.'$k'.err \
    $(cat shell2.'$bowtiedate'.'$k'.err | grep processed - | cut -d: -f2) \
    $(cat shell2.'$bowtiedate'.'$k'.err | grep least - | cut -d: -f2) \
    $(cat shell2.'$bowtiedate'.'$k'.err | grep failed - | cut -d: -f2) \
    $(cat shell2.'$bowtiedate'.'$k'.err | grep suppressed - | cut -d: -f2) >> stats2
          ' >> testcodePostBowtieStat$bowtiedate
        done
      j+=1
    done <$1



chmod a+x testcodePostBowtieStat$bowtiedate
chmod a+x testcodePostBowtie
chmod a+x testcodePostBowtie2
