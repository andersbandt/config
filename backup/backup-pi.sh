#!/bin/bash
set -euo pipefail

TODAY="$(date +%Y-%m-%d)"
BACKPATH="/mnt/usb/backup"  # adjust to your USB mount point

if ! mountpoint -q /mnt/usb; then
    echo "ERROR: USB drive not mounted!"
    exit 1
fi

# Ensure backup directory exists
mkdir -p "$BACKPATH"

# Delete backups older than 2 weeks
find "$BACKPATH" -name "*.tar.gz" -mtime +14 -delete

echo "Starting backup..."
START=$(date +%s)

tar czvf "$BACKPATH/pi-backup-$TODAY.tar.gz" \
    /home/pi \
    /etc/systemd/system \
    /etc/cron.d \
    /etc/crontab \
    /etc/fstab \
    /etc/hosts \
    /etc/hostname \
    /etc/network \
    /etc/wpa_supplicant \
    /etc/apt/sources.list.d \
    /opt \
    2>/dev/null || true

END=$(date +%s)
DIFF=$((END - START))

echo "Backup complete in ${DIFF}s: $BACKPATH/pi-backup-$TODAY.tar.gz"
