#!/usr/bin/env bash

set -euo pipefail

# =========================
# CONFIG
# =========================
SRC_BASE="/mnt/668E28458E280FDB"
DEST_BASE="/run/media/patrix/Elements SE"

# =========================
# HELP
# =========================
usage() {
    echo "Usage:"
    echo "  $0 [dir] [dry|sync|dry-nodelete|sync-nodelete|status]"
    echo ""
    echo "If dir is omitted, fzf picker will be used."
    exit 1
}

# =========================
# ARGUMENTS
# =========================
DIR="${1:-}"
MODE="${2:-dry-nodelete}"

if [[ "$DIR" == "--help" || "$DIR" == "-h" ]]; then
    usage
fi

# =========================
# FZF DIRECTORY PICKER
# =========================
if [[ -z "$DIR" ]]; then
    if command -v fzf >/dev/null 2>&1; then
        DIR=$(find "$SRC_BASE" -maxdepth 1 -mindepth 1 -type d \
                | sed "s|$SRC_BASE/||" \
            | fzf --prompt="Select directory: ")
    else
        echo "❌ No directory provided and fzf is not installed."
        exit 1
    fi
fi

if [[ -z "$DIR" ]]; then
    echo "❌ No directory selected."
    exit 1
fi

SRC="$SRC_BASE/$DIR"
DEST="$DEST_BASE/$DIR"

# =========================
# VALIDATION
# =========================
if [[ ! -d "$SRC" ]]; then
    echo "❌ Source does not exist: $SRC"
    exit 1
fi

if [[ ! -d "$DEST_BASE" ]]; then
    echo "❌ Destination base not mounted: $DEST_BASE"
    exit 1
fi

echo "===================================="
echo "📂 Source:      $SRC/"
echo "📀 Destination: $DEST/"
echo "⚙️ Mode:        $MODE"
echo "===================================="

# =========================
# STATUS MODE
# =========================
if [[ "$MODE" == "status" ]]; then
    du -sh "$SRC" "$DEST" 2>/dev/null || true
    rsync -avhni "$SRC/" "$DEST/" | head -n 50
    exit 0
fi

# =========================
# CONFIRMATION (FIXED)
# =========================
echo ""
read -r -p "⚠️ Proceed with this operation? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
    echo "❌ Cancelled."
    exit 0
fi

# =========================
# RSYNC OPTIONS
# =========================
RSYNC_OPTS="-avhP --fsync --itemize-changes"

case "$MODE" in
    dry)
        RSYNC_OPTS="$RSYNC_OPTS --dry-run --delete --stats"
        ;;
    sync)
        RSYNC_OPTS="$RSYNC_OPTS --delete"
        ;;
    dry-nodelete)
        RSYNC_OPTS="$RSYNC_OPTS --dry-run --stats"
        ;;
    sync-nodelete)
        ;;
    *)
        usage
        ;;
esac

# =========================
# RUN
# =========================
echo ""
echo "🚀 Running rsync..."
echo "Command: rsync $RSYNC_OPTS \"$SRC/\" \"$DEST/\""
echo ""

rsync $RSYNC_OPTS "$SRC/" "$DEST/"

echo ""
echo "✅ Done."
