#!/bin/bash
set -e

echo "=== START CUSTOM ==="

# -------------------------
# 1) Find cached LUSTIFY
# -------------------------
CACHE_ROOT="/runpod-volume/huggingface-cache/hub/models--shootstuff--LUSTIFY-v2.0"

SNAPSHOT=$(find "$CACHE_ROOT/snapshots" -mindepth 1 -maxdepth 1 -type d | head -n 1)

if [ -z "$SNAPSHOT" ]; then
echo "ERROR: LUSTIFY snapshot not found at $CACHE_ROOT"
exit 1
fi

MODEL=$(find "$SNAPSHOT" -name "lustifySDXLNSFWSFW_v20.safetensors" -print -quit)

if [ -z "$MODEL" ]; then
echo "ERROR: LUSTIFY checkpoint not found"
find "$SNAPSHOT" -maxdepth 3 -type f
exit 1
fi

echo "LUSTIFY checkpoint found: $MODEL"

# -------------------------
# 2) Prepare persistent dirs
# -------------------------
BASE="/runpod-volume/instantid-assets"

mkdir -p "$BASE/instantid"
mkdir -p "$BASE/controlnet"
mkdir -p "$BASE/insightface/models"
mkdir -p /comfyui/models/checkpoints
mkdir -p /comfyui/models/instantid
mkdir -p /comfyui/models/controlnet
mkdir -p /comfyui/models/insightface/models

# -------------------------
# 3) Download InstantID assets if missing
# -------------------------
python3 <<'PY'
from huggingface_hub import hf_hub_download, snapshot_download
import os

base = "/runpod-volume/instantid-assets"

# ip-adapter.bin
hf_hub_download(
repo_id="InstantX/InstantID",
filename="ip-adapter.bin",
local_dir=os.path.join(base, "instantid"),
local_dir_use_symlinks=False
)

# InstantID ControlNet
hf_hub_download(
repo_id="InstantX/InstantID",
filename="ControlNetModel/diffusion_pytorch_model.safetensors",
local_dir=os.path.join(base, "controlnet"),
local_dir_use_symlinks=False
)

# antelopev2
snapshot_download(
repo_id="kidyu/antelopev2-for-InstantID-ComfyUI",
local_dir=os.path.join(base, "insightface/models/antelopev2"),
local_dir_use_symlinks=False
)
PY

# -------------------------
# 4) Link everything into ComfyUI
# -------------------------
ln -sf "$MODEL" /comfyui/models/checkpoints/lustifySDXLNSFWSFW_v20.safetensors
ln -sf "$BASE/instantid/ip-adapter.bin" /comfyui/models/instantid/ip-adapter.bin
ln -sf "$BASE/controlnet/ControlNetModel/diffusion_pytorch_model.safetensors" /comfyui/models/controlnet/instantid-controlnet.safetensors

rm -rf /comfyui/models/insightface/models/antelopev2
ln -s "$BASE/insightface/models/antelopev2" /comfyui/models/insightface/models/antelopev2

echo "=== LINKS READY ==="
ls -la /comfyui/models/checkpoints || true
ls -la /comfyui/models/instantid || true
ls -la /comfyui/models/controlnet || true
ls -la /comfyui/models/insightface/models || true

exec /start.sh
