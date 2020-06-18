library(rhdfs)
library(rmr2)
library(rJava)
library(RJSONIO)

hdfs.init()

aa_count <- function(lines) { 
  words <- to.dfs(do.call(c, strsplit((lines),'')))
  fs.ptr <- mapreduce(input=words,
                      map=function(k,v) keyval(v,1),
                      reduce=function(k,v) keyval(k, sum(v)))
  raw <- from.dfs(fs.ptr)
  out <- raw$val
  names(out) <- raw$key
  out[order(names(out))]
} 

open_input_file <- function(input_file){
  # Open file from HDFS 
  file = hdfs.file(input_file, 'r')
  raw = hdfs.read(file)
  readable_file = rawToChar(raw)
  
  return(readable_file)
}

filter_file <- function(file){
  # Split the file on '\n'
  sub_sequence = strsplit(file, '\n')
  
  # Keep all lines except the header
  seq = sub_sequence[[1]][2: length(sub_sequence[[1]])]
  
  # Get header
  header = sub_sequence[[1]][1]
  
  # Paste the splitted sequences together
  seq = paste(seq, collapse = '')
  
  return(header_seq = list("header" = header, "seq" = seq))
}

get_polarity <- function(seq){
  # Use the word count function to count the amount of amino acids
  table <- aa_count(seq) # This uses mapreduce (black box)
  table <- data.frame(table)
  
  # Get the amino acids that are used
  aminoacids <- rownames(table)
  
  # Get the amount of every used amino acid
  appearance <- table$table
  
  # Create a data frame that contains the polarity for every amino acid
  polarity_df <- data.frame('aa' = c('A', 'R', 'N', 'D', 'C', 'F', 'Q', 'E', 'G',
                                     'H', 'I', 'L', 'K', 'M', 'P', 'S', 'T', 'W',
                                     'Y', 'V'),
                            'pol' = c(-1, 1, 1, 1, 1, -1, 1, 1, 1, 1, -1, -1, 1, -1, -1, 1, 1, -1, 1, -1), row.names = TRUE)  #apolair = -1, polair = 1
  
  # Calculate the polarity for the protein
  polarity = 0
  for (i in 1:length(aminoacids)){
    polarity = polarity + polarity_df[aminoacids[i],] * appearance[i]
  }
  return(polarity)
}

save_to_hdfs <- function(polarity, header, output_file){
  # What is the final conclusion and save it with the header
  if(polarity > 0){
    text <- paste(header, "\nProtein is polar")
  } else if(polarity == 0){
    text <- paste(header, "\nProtein is neutral")
  } else{
    text <- paste(header, "\nProtein is apolar")
  }
  
  # Create a file in hdfs
  modelfile <- hdfs.file(output_file, "w")
  
  # Convert the text that is created to a JSON-format text
  data1 <- toJSON(text)
  
  # Convert the JSON characters to a raw-format text
  data2 <- charToRaw(data1)
  
  # Write the raw-text to the file in hdfs
  hdfs.write(data2,modelfile)
  
  # Close the file
  hdfs.close(modelfile)
}

file <- open_input_file('/home/haptoglobin.txt')
header_seq <- filter_file(file)
polarity <- get_polarity(header_seq$seq)
save_to_hdfs(polarity, header_seq$header, '/home/text.txt')
