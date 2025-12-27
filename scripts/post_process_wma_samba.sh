#!/bin/bash
set -euo pipefail

SRC_DIR="$1"
DEST_BASE="/samba"
DEST_DIR="$DEST_BASE/$(basename "$SRC_DIR")"

echo "[+] Converting OGG → WMA"

find "$SRC_DIR" -type f -name '*.ogg' -print0 | while IFS= read -r -d '' f; do
    out="${f%.ogg}.wma"
    ffmpeg -y -loglevel error -i "$f" -acodec wmav2 -ab 192k "$out"
    rm -f "$f"
done

echo "[+] Uploading to Samba"
mkdir -p "$DEST_DIR"
cp -a "$SRC_DIR" "$DEST_DIR"

echo "[+] Syncing"
sync

echo "[+] Removing local copy"
rm -rf "$SRC_DIR"

echo "[✓] OGG → WMA pipeline complete"
