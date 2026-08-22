FROM runpod/worker-comfyui:5.4.1-base-cuda12.8.1

# --------------------------------------------------
# Custom nodes
# --------------------------------------------------

RUN git clone https://github.com/cubiq/ComfyUI_InstantID.git \
/comfyui/custom_nodes/ComfyUI_InstantID


# --------------------------------------------------
# Dependencies
# --------------------------------------------------

RUN pip install --no-cache-dir \
-r /comfyui/custom_nodes/comfyui-tooling-nodes/requirements.txt

RUN pip install --no-cache-dir \
-r /comfyui/custom_nodes/ComfyUI_InstantID/requirements.txt \
insightface \
onnxruntime \
onnxruntime-gpu \
huggingface_hub


# --------------------------------------------------
# Model directories
# --------------------------------------------------

RUN mkdir -p \
/comfyui/models/instantid \
/comfyui/models/controlnet \
/comfyui/models/insightface/models/antelopev2 \
/comfyui/models/checkpoints


# --------------------------------------------------
# Bake InstantID assets into Docker image
# --------------------------------------------------

RUN python - <<'PY'
from huggingface_hub import hf_hub_download, snapshot_download
import os
import shutil

# InstantID IP Adapter
hf_hub_download(
repo_id="InstantX/InstantID",
filename="ip-adapter.bin",
local_dir="/comfyui/models/instantid"
)

# InstantID ControlNet
hf_hub_download(
repo_id="InstantX/InstantID",
filename="ControlNetModel/diffusion_pytorch_model.safetensors",
local_dir="/tmp/instantid"
)

src = "/tmp/instantid/ControlNetModel/diffusion_pytorch_model.safetensors"
dst = "/comfyui/models/controlnet/instantid-controlnet.safetensors"

shutil.copy2(src, dst)

# InsightFace antelopev2
snapshot_download(
repo_id="kidyu/antelopev2-for-InstantID-ComfyUI",
local_dir="/comfyui/models/insightface/models/antelopev2"
)

print("InstantID assets installed")
PY


# --------------------------------------------------
# Startup script
# --------------------------------------------------
COPY image.png /comfyui/input/wilma.png
COPY start-custom.sh /start-custom.sh
RUN chmod +x /start-custom.sh

CMD ["/start-custom.sh"]
