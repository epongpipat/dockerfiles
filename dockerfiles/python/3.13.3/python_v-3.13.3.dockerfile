FROM python:3.13.3-slim

# Install system dependencies if needed
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements.txt into the container
COPY requirements.txt .

# Install Python packages from the file
RUN pip install --no-cache-dir -r requirements.txt

# Default command to run bash shell
CMD ["/bin/bash"]