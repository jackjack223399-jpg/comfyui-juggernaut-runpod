#!/bin/bash
set -e

echo "=== STARTING LUSTIFY + INSTANTID ==="

CACHE_ROOT="/runpod-volume/huggingface-cache/hub/models--shootstuff--LUSTIFY-v2.0"

echo "Looking for cached LUSTIFY..."
echo "Cache root: $CACHE_ROOT"

SNAPSHOT=$(find "$CACHE_ROOT/snapshots" \
-mindepth 1 \
-maxdepth 1 \
-type d \
| head -n 1)

if [ -z "$SNAPSHOT" ]; then
echo "ERROR: LUSTIFY cached snapshot not found"
exit 1
fi

echo "Snapshot: $SNAPSHOT"

MODEL=$(find "$SNAPSHOT" \
-name "lustifySDXLNSFWSFW_v20.safetensors" \
-print -quit)

if [ -z "$MODEL" ]; then
echo "ERROR: LUSTIFY checkpoint not found"
echo "Available files:"
find "$SNAPSHOT" -maxdepth 3 -print
exit 1
fi

echo "LUSTIFY found: $MODEL"

mkdir -p /comfyui/models/checkpoints

ln -sf "$MODEL" \
/comfyui/models/checkpoints/lustifySDXLNSFWSFW_v20.safetensors

echo "LUSTIFY linked"

echo "Checking InstantID assets..."

ls -lh /comfyui/models/instantid/ip-adapter.bin
ls -lh /comfyui/models/controlnet/instantid-controlnet.safetensors
ls -lh /comfyui/models/insightface/models/antelopev2

echo "=== ALL MODELS READY ==="

exec /start.sh
