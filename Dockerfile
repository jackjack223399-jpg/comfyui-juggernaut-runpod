FROM runpod/worker-comfyui:5.4.1-base-cuda12.8.1

RUN git clone https://github.com/cubiq/ComfyUI_InstantID.git /comfyui/custom_nodes/ComfyUI_InstantID

RUN pip install -r /comfyui/custom_nodes/ComfyUI_InstantID/requirements.txt
RUN pip install insightface onnxruntime onnxruntime-gpu huggingface_hub

COPY start-custom.sh /start-custom.sh
RUN chmod +x /start-custom.sh

CMD ["/start-custom.sh"]
