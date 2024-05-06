# casestudy-5
# process_file.sh
•	`aws s3 ls s3://$BUCKET_NAME/$IN_FOLDER/`: This command lists the contents of the specified S3 bucket's `/out` folder. The output is piped to the `while` loop.
•	`while read -r line;`: This loop reads each line of the output from the `aws s3 ls` command.
•	`filename=$(echo $line|awk '{print $4}')`: This line extracts the fourth column from each line of the output, which represents the filename of the object in the S3 bucket. The filename is stored in the `filename` variable.
•	`if [ -n "$filename" ]; then`: This condition checks if the filename variable is not empty, indicating that a file exists in the S3 bucket.
•	`word_count=$(aws s3 cp s3://$BUCKET_NAME/$IN_FOLDER/$filename - | wc -w)`: This command downloads the file from the S3 bucket (`s3://$BUCKET_NAME/$IN_FOLDER/$filename`) to the standard output (`-`) and pipes it to the `wc -w` command, which counts the number of words in the file. The word count is stored in the `word_count` variable.
•	`execution_date=$(date '+%Y-%m-%d %H:%M:%S')`: This line retrieves the current date and time in the specified format (`YYYY-MM-DD HH:MM:SS`) and stores it in the `execution_date` variable.
•	`echo "$filename: $word_count words processed at $execution_date" >> $FILE`: This command appends a line to the `count.txt` file containing the filename, word count, and execution date.
•	`aws s3 cp $FILE s3://$BUCKET_NAME/$OUT_FOLDER/`: This command copies the `count.txt` file to the `/count` folder in the same S3 bucket, allowing for storage and future reference.



# manage_instanmces.sh
This script is designed to start or stop EC2 instances based on the current time of day. Let's break down its components:
•	`start_instances()`: This is a function definition for starting EC2 instances.
•	`aws ec2 start-instances --instance-ids your-instance-ids`: This command is executed within the `start_instances()` function and uses the AWS CLI (`aws ec2 start-instances`) to start the EC2 instances specified by their instance IDs (`your-instance-ids`). 
•	`stop_instances()`: This is a function definition for stopping EC2 instances.
•	`aws ec2 stop-instances --instance-ids your-instance-ids`: Similar to the `start_instances()` function, this command is executed within the `stop_instances()` function to stop the EC2 instances specified by their instance IDs 
•	`current_time=$(date +%H)`: This line retrieves the current hour of the day (in 24-hour format) using the `date` command and stores it in the `current_time` variable.
•	`if [ "$current_time" -eq 18 ]; then`: This conditional statement checks if the current time is 18:00 (6:00 PM) using the `eq` operator (equals).
•	`start_instances`: If the current time is 18:00, the `start_instances` function is called to start the specified EC2 instances.
•	`elif [ "$current_time" -eq 21 ]; then`: This `elif` (else-if) statement checks if the current time is 21:00 (9:00 PM).
•	`stop_instances`: If the current time is 21:00, the `stop_instances` function is called to stop the specified EC2 instances.

Overall, this script provides a simple automation mechanism to start or stop EC2 instances based on the time of day, allowing for cost optimization and resource management.





# delete_old-snapshot.sh

•	`DAYS_TO_KEEP`: Specifies the number of days to retain snapshots.
•	VOLUME_ID`: Specifies the volume ID for which snapshots need to be managed.
•	The `date` command with the `-d` option is used to calculate the cutoff date by subtracting the specified number of days from the current date. The result is formatted as `YYYY-MM-DD` and stored in the `CUTOFF_DATE` variable.
•	The `aws ec2 describe-snapshots` command retrieves information about snapshots associated with the specified volume ID.
•	The `--query` parameter filters snapshots based on the cutoff date.
•	The `--output text` parameter ensures that the output is in text format.
•	The `xargs` command reads the snapshot IDs from the output and passes them as arguments to the `aws ec2 delete-snapshot` command to delete each snapshot.

