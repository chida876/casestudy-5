import boto3
import os
import datetime
# Initialize AWS clients
s3 = boto3.client('s3')
ec2 = boto3.client('ec2')
def lambda_handler(event, context):
    # Get the bucket name and file key from the event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    
    # Check if the file is in the /out folder
    if os.path.dirname(file_key) == 'out':
        # Read the text file from S3
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        text = response['Body'].read().decode('utf-8')
        
        # Count words in the text file
        word_count = len(text.split())
        
        # Update count.txt with word count and execution date
        update_count_file(word_count, bucket_name)
        
    # Check the current time and start/stop EC2 instances accordingly
    current_hour = datetime.datetime.now().hour
    if current_hour == 18:
        manage_ec2_instances('stop')
    elif current_hour == 21:
        manage_ec2_instances('start')
        
def update_count_file(word_count, bucket_name):
    current_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    count_content = f"Word count: {word_count}, Execution date: {current_date}"
    s3.put_object(Body=count_content, Bucket=bucket_name, Key='count/count.txt')

def manage_ec2_instances(action):
    instance_ids = ['i-05ff2a36a8baa92c4']  # Add your instance ID here

    if action == 'stop':
        ec2.stop_instances(InstanceIds=instance_ids)
    elif action == 'start':
        ec2.start_instances(InstanceIds=instance_ids)

