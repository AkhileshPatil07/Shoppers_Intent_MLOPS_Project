# --- Simple English summary ---
# A Dockerfile is a recipe that packages this whole app (code + Python +
# libraries) into one "container image" that runs the same way on any
# machine — your laptop, a teammate's laptop, or a cloud server.

FROM python:3.11-slim

WORKDIR /app

# Install dependencies first (this layer gets cached, so rebuilds are fast
# unless requirements.txt changes)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project
COPY . .

EXPOSE 8000

# Start the FastAPI app with uvicorn
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
