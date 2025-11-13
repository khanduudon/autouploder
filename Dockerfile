# Base image
FROM sailvessel/ubuntu:latest

# Set working directory
WORKDIR /app

# Copy all files into container
COPY . .

# Install system dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y --fix-missing \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    ffmpeg \
    aria2 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# (❌ Removed broken appxdl URL)
# If you ever get a valid appxdl binary later, you can enable this block:
# RUN wget https://new-working-link.com/appxdl && \
#     mv appxdl /usr/local/bin/appxdl && \
#     chmod +x /usr/local/bin/appxdl

# Setup Python virtual environment and install required packages
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r master.txt

# Add virtual environment to PATH
ENV PATH="/usr/local/bin:/venv/bin:$PATH"

# Expose port (for Gunicorn or Flask)
EXPOSE 8000

# Start Gunicorn server
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
