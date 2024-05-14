#!/bin/bash

# Variables
BUCKET_NAME="my-bucket-casestudy5"
IN_FOLDER="input"
OUT_FOLDER="count"
FILE="count.txt"

# Check for new files
aws s3 ls s3://$BUCKET_NAME/$IN_FOLDER/ | while read -r line;
do
  filename=$(echo $line|awk '{print $4}')
  if [ -n "$filename" ]; then
    # Process file
    word_count=$(aws s3 cp s3://$BUCKET_NAME/$IN_FOLDER/$filename - | wc -w)
    execution_date=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$filename: $word_count words processed at $execution_date" >> $FILE
    aws s3 cp $FILE s3://$BUCKET_NAME/$OUT_FOLDER/
  fi
done
