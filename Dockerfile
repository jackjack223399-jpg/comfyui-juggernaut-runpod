FROM runpod/worker-comfyui:5.4.1-base

USER root

RUN pip install --no-cache-dir huggingface_hub

COPY start-custom.sh /comfyui/start-custom.sh
RUN chmod +x /comfyui/start-custom.sh

COPY wilma.png /comfyui/input/wilma.png
