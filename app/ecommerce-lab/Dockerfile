FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Environment variables for OTel
ENV OTEL_SERVICE_NAME="app-ecomm"
ENV OTEL_TRACES_EXPORTER="otlp"
ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317"
ENV OTEL_PYTHON_LOG_LEVEL="debug"
ENV OTEL_LOG_LEVEL="debug"

# Create app directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Bootstrap OTLP 
RUN opentelemetry-bootstrap -a install

# Copy application code
COPY . /app

# Expose port
EXPOSE 8080

# Command to run the application
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8080"]
