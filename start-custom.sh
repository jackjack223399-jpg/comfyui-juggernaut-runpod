#!/bin/bash
set -e

echo "=== Custom startup: begin ==="

mkdir -p /comfyui/models/checkpoints
mkdir -p /comfyui/custom_nodes
mkdir -p /comfyui/input

cd /comfyui/custom_nodes

if [ ! -d "Comfyui-QwenEditUtils" ]; then
git clone https://github.com/lrzjason/Comfyui-QwenEditUtils.git
fi

if [ -f "/comfyui/custom_nodes/Comfyui-QwenEditUtils/requirements.txt" ]; then
pip install --no-cache-dir -r /comfyui/custom_nodes/Comfyui-QwenEditUtils/requirements.txt
fi

python - <<'PY'
from huggingface_hub import hf_hub_download

hf_hub_download(
repo_id="Phr00t/Qwen-Image-Edit-Rapid-AIO",
filename="Qwen-Rapid-AIO-NSFW-v19.safetensors",
local_dir="/comfyui/models/checkpoints",
local_dir_use_symlinks=False
)
PY

echo "=== Custom startup: done ==="
