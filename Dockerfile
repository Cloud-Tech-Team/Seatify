# Use official Python 3.9 slim image (more stable for production)
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y nginx

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Environment variables - these will be overridden by Cloud Run settings
ENV DBAUTHTOKEN=""
ENV SECRET_KEY="default-dev-secret-key-replace-in-cloud-run"
ENV DEBUG="False"
ENV SECURE_COOKIES="True"
ENV USE_TURSO="False"
ENV TURSO_DATABASE_URL=""

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose HTTP port
EXPOSE 80

# Start both services
CMD nginx -g "daemon off;" & \
    gunicorn Seatify.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 120
