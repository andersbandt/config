#!/bin/bash
set -euo pipefail

TODAY="$(date +%Y-%m-%d)"
BACKPATH="/mnt/backdrive_1/backup"

# Check if backup drive is mounted
if ! mountpoint -q /mnt/backdrive_1; then
    echo "ERROR: Backup drive not mounted!"
    exit 1
fi

BACKUP_DIR="$BACKPATH/$TODAY"
mkdir -p "$BACKUP_DIR"

START=$(date +%s)

echo "Creating backup at path: $BACKUP_DIR"

# Delete backup directories older than 2 weeks
#find "$BACKPATH" -mindepth 1 -maxdepth 1 -type d -mtime +14 -exec rm -rf {} +

# Save lists of installed packages for easy restore
echo "Saving package lists..."
snap list > "$BACKUP_DIR/snap-packages.txt" 2>/dev/null || echo "snap not installed" > "$BACKUP_DIR/snap-packages.txt"
flatpak list --app --columns=application > "$BACKUP_DIR/flatpak-packages.txt" 2>/dev/null || echo "flatpak not installed" > "$BACKUP_DIR/flatpak-packages.txt"
dpkg --get-selections > "$BACKUP_DIR/dpkg-packages.txt" 2>/dev/null || true
pip list --format=freeze > "$BACKUP_DIR/pip-packages.txt" 2>/dev/null || echo "pip not installed" > "$BACKUP_DIR/pip-packages.txt"

# j = bzip2 (slower, better compression)
# z = gzip (faster, less compression)
tar jcvf "$BACKUP_DIR/my-backup-$TODAY.tar.bz2" \
    --one-file-system \
    --exclude=/home/anders/Pictures \
    --exclude=/home/anders/.cache \
    --exclude=/home/anders/ncs/downloads \
    --exclude=/var/cache \
    --exclude=/var/log \
    --exclude=/var/tmp \
    --exclude=/var/lib/snapd \
    --exclude=/var/lib/flatpak \
    --exclude=/var/lib/docker \
    --exclude=/home/anders/.local/share/Steam \
    /

END=$(date +%s)
ELAPSED=$((END - START))
HOURS=$((ELAPSED / 3600))
MINUTES=$(( (ELAPSED % 3600) / 60 ))
SECONDS=$((ELAPSED % 60))

printf "BACKUP COMPLETE in %dh %dm %ds\n" "$HOURS" "$MINUTES" "$SECONDS"
