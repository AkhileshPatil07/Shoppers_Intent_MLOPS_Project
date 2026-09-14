# --- Python base image ---
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install Linux system dependency required by ML libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends libgomp1 && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Render will provide the actual PORT
EXPOSE 8000

# Start FastAPI application
CMD ["sh", "-c", "uvicorn api.main:app --host 0.0.0.0 --port ${PORT:-8000}"]