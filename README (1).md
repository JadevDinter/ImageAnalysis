# Image analysis final project
Authors: Ilse den Brok, Jade van Dinter, Carlijn Fransen en Carleen Rossing

## Getting started with this project
- Download Oracle Virtual Machine from: https://www.virtualbox.org/wiki/Downloads
- Download the Mint-Hadoop.ova file from: http://login.hpc.fs.uni-lj.si/download/ This Mint-Hadoop.ova file contains a working version of Hadoop and RStudio.
- Start the terminal and type: start-dfs.sh
- Write in the terminal: start-yarn.sh
- Download our R script from your mail and place it in ~/Documents
- Go to your Documents in the terminal: cd Documents
- Write in the terminal: rstudio ImageAnalysis.R
- Set the Environment Variables in the R console: 
Sys.setenv(HADOOP_OPTS="-Djava.library.path=/usr/local/hadoop/lib/native")
Sys.setenv(HADOOP_HOME="/usr/local/hadoop")
Sys.setenv(HADOOP_CMD="/usr/local/hadoop/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.5.jar")
Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64")
Sys.setenv(HADOOP_OPTS="-Djava.library.path=/usr/local/hadoop/lib/native")
Sys.setenv(HADOOP_HOME="/usr/local/hadoop")
Sys.setenv(HADOOP_CMD="/usr/local/hadoop/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.5.jar")
Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64")
- Install the packages in the R console: (this will take a while)
install.packages("rJava")
install.packages("RJSONIO")
install.packages("devtools")
install.packages("rhdfs")
install.packages("rmr2")
- If installing rhdfs doesn't work, try this:
Download rmr and rhdfs from https://github.com/RevolutionAnalytics/RHadoop/wiki/Downloads
and type in the r console, 
install.packages("~/Downloads/rmr2_3.3.1.tar.gz", repos=NULL, type="source")
install.packages("~/Downloads/rhdfs_1.0.8.tar.gz", repos=NULL, type="source")
- Download a protein sequence file from ncbi (haptoglobin.txt)
- Copy to hdfs in the terminal:
hdfs dfs -put haptoglobin.txt /home/
- See if it worked (it could be that the linux mint time is one hour behind the real time): hadoop fs -ls -R /home/
- Run the ImageAnalysis.R script
- See if it worked: hadoop fs -ls -R /home/
- Close deamons: stop-yarn.sh
- Stop namenodes: stop-dfs.sh


