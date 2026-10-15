FROM python:3.12-slim
WORKDIR /workspace

COPY common/scripts/local-gateway.py /workspace/local-gateway.py
COPY frontend/index.html /workspace/frontend/index.html

ENV GATEWAY_PORT=3001
EXPOSE 3001
CMD ["python", "/workspace/local-gateway.py"]