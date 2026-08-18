FROM runpod/worker-comfyui:main-base

RUN mkdir -p /comfyui/models/checkpoints

RUN wget -O /comfyui/models/checkpoints/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors \
"https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/resolve/main/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors"

RUN git clone https://github.com/Acly/comfyui-tooling-nodes.git \
/comfyui/custom_nodes/comfyui-tooling-nodes

RUN if [ -f /comfyui/custom_nodes/comfyui-tooling-nodes/requirements.txt ]; then \
pip install --no-cache-dir -r /comfyui/custom_nodes/comfyui-tooling-nodes/requirements.txt; \
fi
