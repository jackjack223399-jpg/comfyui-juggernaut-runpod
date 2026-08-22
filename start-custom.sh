#!/bin/bash
set -e

CACHE_ROOT="/runpod-volume/huggingface-cache/hub/models--shootstuff--LUSTIFY-v2.0"

echo "Looking for LUSTIFY in: $CACHE_ROOT"

SNAPSHOT=$(find "$CACHE_ROOT/snapshots" -mindepth 1 -maxdepth 1 -type d | head -n 1)

if [ -z "$SNAPSHOT" ]; then
echo "ERROR: Hugging Face snapshot not found"
exit 1
fi

echo "Snapshot found: $SNAPSHOT"

MODEL=$(find "$SNAPSHOT" \
-name "lustifySDXLNSFWSFW_v20.safetensors" \
-print -quit)

if [ -z "$MODEL" ]; then
echo "ERROR: LUSTIFY checkpoint not found"
echo "Files available in snapshot:"
find "$SNAPSHOT" -maxdepth 2 -print
exit 1
fi

echo "LUSTIFY found: $MODEL"

mkdir -p /comfyui/models/checkpoints

ln -sf "$MODEL" \
/comfyui/models/checkpoints/lustifySDXLNSFWSFW_v20.safetensors

echo "Checkpoint linked successfully"

exec /start.sh
