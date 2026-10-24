FROM python:3.11-slim
WORKDIR /app
COPY start.sh /app/
CMD ["bash", "start.sh"]
