FROM python:3.11 AS builder
WORKDIR /app
RUN mkdir -p /app/src
COPY app.py /app/src/
RUN echo "build done" > /app/build.txt

FROM python:3.11
ENV APP_HOME=/app
WORKDIR $APP_HOME
COPY --from=builder /app/src /app/src
ADD archive.tar.gz /app/data/
EXPOSE 8080
USER appuser
CMD ["python", "src/app.py"]
