FROM python:3.11
ENV APP_HOME=/app
ENV DEBUG=1
WORKDIR /app
RUN mkdir -p /app/data
RUN echo "initialized" > /app/data/init.txt
COPY *.py /app/
ENTRYPOINT ["python"]
CMD ["app.py"]
