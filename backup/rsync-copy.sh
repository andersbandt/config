#!/bin/bash
# rsync-copy.sh — Mirror source directories to a destination (e.g. network-mapped Pi drive)
#
# Usage:
#   ./rsync-copy.sh              # run with defaults below
#   ./rsync-copy.sh --delete     # mirror mode: delete files at dest that are gone from src
#   ./rsync-copy.sh --dry-run    # preview what would happen
#
# For WSL: Windows mapped drives are at /mnt/x/, /mnt/y/, etc.
# For Pi:  Mount your network share first, then point DEST at the mountpoint.

set -euo pipefail

# --- Configure these ---
SOURCES=(
    "/cygdrive/x"
    #"/home/pi/Projects"
    # Add more source paths here
)
DEST="/cygdrive/f/Backup/Computer/pi_grow/"   # e.g. Windows X:\Documents, or /mnt/usb/pi-sync
# -----------------------

DELETE_FLAG=""
DRY_RUN=""

for arg in "$@"; do
    case "$arg" in
        --delete)  DELETE_FLAG="--delete" ;;
        --dry-run) DRY_RUN="--dry-run" ;;
        *)
            echo "Unknown argument: $arg"
            echo "Usage: $0 [--delete] [--dry-run]"
            exit 1
            ;;
    esac
done

# Verify destination is reachable
if [ ! -d "$DEST" ]; then
    echo "ERROR: Destination not found or not mounted: $DEST"
    exit 1
fi

echo "Syncing to: $DEST"
[ -n "$DRY_RUN" ] && echo "(dry run — no changes will be made)"
[ -n "$DELETE_FLAG" ] && echo "(delete mode — files removed from source will be removed from dest)"
echo ""

START=$(date +%s)

for SRC in "${SOURCES[@]}"; do
    if [ ! -d "$SRC" ]; then
        echo "WARNING: Source not found, skipping: $SRC"
        continue
    fi
    echo "--- Syncing: $SRC"
    rsync -av --progress --partial \
        $DELETE_FLAG \
        $DRY_RUN \
        "$SRC/" "$DEST/$(basename "$SRC")/"
    echo ""
done

END=$(date +%s)
DIFF=$((END - START))
echo "Done in ${DIFF}s."
