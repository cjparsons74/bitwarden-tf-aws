#!/bin/bash
# shellcheck disable=SC2154
set -euo pipefail

TODAY=$(date +'%Y%m%d')

# Stop the app
/usr/local/bin/docker-compose -f /home/ec2-user/bitwarden/compose/docker-compose.yml down

# Backup and upload to S3
sudo tar cfz "$TODAY"_bitwarden-backup.tar.gz /home/ec2-user/bitwarden/{bitwarden-data,letsencrypt,mysql}
/usr/bin/aws s3 cp "$TODAY"_bitwarden-backup.tar.gz s3://"${bucket}"/"$TODAY"_bitwarden-backup.tar.gz --sse
sudo rm "$TODAY"_bitwarden-backup.tar.gz

# Start the app
/usr/local/bin/docker-compose -f /home/ec2-user/bitwarden/compose/docker-compose.yml up -d
