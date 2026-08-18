FROM runpod/worker-comfyui:main-base

WORKDIR /comfyui

RUN mkdir -p /comfyui/models/checkpoints

RUN wget -O /comfyui/models/checkpoints/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors \
"https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/resolve/main/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors"
