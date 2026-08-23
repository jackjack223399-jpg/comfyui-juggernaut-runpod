FROM runpod/worker-comfyui:5.8.6-base

USER root

RUN git clone https://github.com/lrzjason/Comfyui-QwenEditUtils.git \
/comfyui/custom_nodes/Comfyui-QwenEditUtils

RUN uv pip install -r /comfyui/requirements.txt \
&& if [ -f /comfyui/custom_nodes/Comfyui-QwenEditUtils/requirements.txt ]; then \
uv pip install -r /comfyui/custom_nodes/Comfyui-QwenEditUtils/requirements.txt; \
fi

RUN mkdir -p /comfyui/input /comfyui/models/checkpoints

COPY wilma.png /comfyui/input/wilma.png
