FROM runpod/worker-comfyui:main-base

RUN git clone https://github.com/Acly/comfyui-tooling-nodes.git \
/comfyui/custom_nodes/comfyui-tooling-nodes

RUN if [ -f /comfyui/custom_nodes/comfyui-tooling-nodes/requirements.txt ]; then \
pip install --no-cache-dir -r /comfyui/custom_nodes/comfyui-tooling-nodes/requirements.txt; \
fi

COPY start-custom.sh /start-custom.sh
RUN chmod +x /start-custom.sh

CMD ["/start-custom.sh"]
