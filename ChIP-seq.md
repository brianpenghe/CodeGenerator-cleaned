This is the totalRNA-seq/RIP-seq pipeline instruction:
# 0. Set up the codes of generating scripts

You can create a soft link to all the scripts and genome references in the ~phe folders if you haven't never done that.

`ln -s ~phe/programs ~/programs; ln -s ~phe/genomes ~/genomes`

# 1. Run the code-generation pipeline
## 1.1 Organize the fastq files in subfolders
If there are only fastq.gz files in subfolders, run `gunzip */*.gz` to extract them

The files you have should look like this

![image](https://github.com/brianpenghe/CodeGenerator/assets/4110443/0e0fd31d-b710-4425-8076-e217166353a6)
