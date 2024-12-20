# Use an official Python base image
FROM python:3.9-slim

# Set a working directory
WORKDIR /app

# Copy files into the container
COPY . .

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r docs/requirements.txt

# Default command to run a script
CMD ["python", "megpipeline.py"]
