#!/bin/bash

# Variables
DAYS_TO_KEEP=14
VOLUME_ID="vol-0dc593a3d860c22e0"

# Get current date in YYYY-MM-DD format
CUTOFF_DATE=$(date -d "-$DAYS_TO_KEEP days" +%Y-%m-%d)

# Describe snapshots and delete old ones
aws ec2 describe-snapshots --filters "Name=volume-id,Values=$VOLUME_ID" --query "Snapshots[?StartTime<'$CUTOFF_DATE'].SnapshotId" --output text | \
xargs -r -n 1 -t aws ec2 delete-snapshot --snapshot-id
