#!/bin/bash

# Variables
DAYS_TO_KEEP=14
VOLUME_ID="your-volume-id"

# Delete old snapshots
aws ec2 describe-snapshots --filters "Name=volume-id,Values=$VOLUME_ID" | \
jq -r '.Snapshots[] | select(.StartTime <= "'$(date -d -$DAYS_TO_KEEP' days ago' + "%Y-%m-%d")'") | .SnapshotId' | \
xargs -r -n 1 -t aws ec2 delete-snapshot --snapshot-id
