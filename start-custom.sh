#!/bin/bash
set -e

CACHE_ROOT="/runpod-volume/huggingface-cache/hub/models--RunDiffusion--Juggernaut-XL-v9"

SNAPSHOT=$(find "$CACHE_ROOT/snapshots" -mindepth 1 -maxdepth 1 -type d | head -n 1)

MODEL=$(find "$SNAPSHOT" -type f -name "Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors" | head -n 1)

if [ -z "$MODEL" ]; then
echo "JuggernautXL checkpoint not found in RunPod model cache"
exit 1
fi

mkdir -p /comfyui/models/checkpoints

ln -sf "$MODEL" \
/comfyui/models/checkpoints/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors

echo "Using cached model: $MODEL"

exec /start.sh
