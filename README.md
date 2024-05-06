# casestudy-5
# process_file.sh
1. `aws s3 ls s3://$BUCKET_NAME/$IN_FOLDER/`: This command lists the contents of the specified S3 bucket's `/out` folder. The output is piped to the `while` loop.
2. `while read -r line;`: This loop reads each line of the output from the `aws s3 ls` command.
3. `filename=$(echo $line|awk '{print $4}')`: This line extracts the fourth column from each line of the output, which represents the filename of the object in the S3 bucket. The filename is stored in the `filename` variable.
4. `if [ -n "$filename" ]; then`: This condition checks if the filename variable is not empty, indicating that a file exists in the S3 bucket.
5. `word_count=$(aws s3 cp s3://$BUCKET_NAME/$IN_FOLDER/$filename - | wc -w)`: This command downloads the file from the S3 bucket (`s3://$BUCKET_NAME/$IN_FOLDER/$filename`) to the standard output (`-`) and pipes it to the `wc -w` command, which counts the number of words in the file. The word count is stored in the `word_count` variable.
6. `execution_date=$(date '+%Y-%m-%d %H:%M:%S')`: This line retrieves the current date and time in the specified format (`YYYY-MM-DD HH:MM:SS`) and stores it in the `execution_date` variable.
7. `echo "$filename: $word_count words processed at $execution_date" >> $FILE`: This command appends a line to the `count.txt` file containing the filename, word count, and execution date.
8. `aws s3 cp $FILE s3://$BUCKET_NAME/$OUT_FOLDER/`: This command copies the `count.txt` file to the `/count` folder in the same S3 bucket, allowing for storage and future reference.
