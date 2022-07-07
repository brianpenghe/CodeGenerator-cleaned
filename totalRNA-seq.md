This is the totalRNA-seq pipeline instruction:

# 1. Run the code-generation pipeline
# 1.1 Organize the fastq files in subfolders
If there are only fastq.gz files in subfolders, run `gunzip */*.gz` to extract them

The files you have should look like this

![image](https://user-images.githubusercontent.com/4110443/177864540-a9130db6-c91e-4225-999e-63b839e625e0.png)

# 1.2 Create a file list (filename 'test' here)
One simple way to do it is `ls > test` and delete the line containing 'test'

The 'test' file should contain all the folder names

![image](https://user-images.githubusercontent.com/4110443/177876758-f870fc07-d086-4d87-9fb3-b17b9db6bcbb.png)

# 1.3 Run the code generator

`~/programs/LocalCodeGeneratorYichengTotalRNAseq.sh test dm6 50 SE`

Then you should see these messages after cleaning old files and generating script files.

![image](https://user-images.githubusercontent.com/4110443/177877172-ae479abf-d0c9-44f3-b9ce-27a6aabb7d04.png)

# 2. Run the actual code
# 2.1 Run fastq trimming
