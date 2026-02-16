#!/bin/bash
set -euo pipefail

TODAY="$(date +%Y-%m-%d)"
BACKPATH="/mnt/backdrive_1/backup"

# Check if backup drive is mounted
if ! mountpoint -q /mnt/backdrive_1; then
    echo "ERROR: Backup drive not mounted!"
    exit 1
fi

echo "Creating backup at path: $BACKPATH"
echo -e "\twith date $TODAY"

# Delete backup files older than 2 weeks
#find "$BACKPATH" -mtime +14 -type f -delete

START=$(date +%s)

# j = bzip2 (slower, better compression)
# z = gzip (faster, less compression)
tar jcvf "$BACKPATH/my-backup-$TODAY.tar.bz2" \
    --one-file-system \
    --exclude=/home/anders/Pictures \
    --exclude=/home/anders/.cache \
    /

END=$(date +%s)
DIFF=$((END - START))
MINUTES=$((DIFF / 60))

echo "BACKUP COMPLETE in $DIFF seconds ($MINUTES minutes)"
