FROM runpod/worker-comfyui:5.8.6-base

USER root

RUN git clone https://github.com/lrzjason/Comfyui-QwenEditUtils.git \
/comfyui/custom_nodes/Comfyui-QwenEditUtils

RUN uv pip install -r /comfyui/requirements.txt \
&& if [ -f /comfyui/custom_nodes/Comfyui-QwenEditUtils/requirements.txt ]; then \
uv pip install -r /comfyui/custom_nodes/Comfyui-QwenEditUtils/requirements.txt; \
fi \
&& uv pip install "transformers>=4.50.3,<5" "huggingface-hub<1.0"

RUN mkdir -p \
/comfyui/input \
/comfyui/models/checkpoints

RUN python - <<'PY'
from huggingface_hub import hf_hub_download

hf_hub_download(
repo_id="Phr00t/Qwen-Image-Edit-Rapid-AIO",
filename="v19/Qwen-Rapid-AIO-NSFW-v19.safetensors",
local_dir="/tmp/qwen"
)
PY

RUN mv \
/tmp/qwen/v19/Qwen-Rapid-AIO-NSFW-v19.safetensors \
/comfyui/models/checkpoints/Qwen-Rapid-AIO-NSFW-v19.safetensors \
&& rm -rf /tmp/qwen

COPY wilma.png /comfyui/input/wilma.png
# rebuid
