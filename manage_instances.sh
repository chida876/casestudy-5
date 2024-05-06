#!/bin/bash

# Start EC2 instances
start_instances() {
  aws ec2 start-instances --instance-ids i-05ff2a36a8baa92c4
}

# Stop EC2 instances
stop_instances() {
  aws ec2 stop-instances --instance-ids i-05ff2a36a8baa92c4
}

# Check current time
current_time=$(date +%H)

# Start or stop instances based on time
if [ "$current_time" -eq 18 ]; then
  start_instances
elif [ "$current_time" -eq 21 ]; then
  stop_instances
fi
