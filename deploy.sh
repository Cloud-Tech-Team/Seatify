#!/bin/bash
# Deployment script for Seatify to Google Cloud Run via Artifact Registry
# Usage: ./deploy.sh PROJECT_ID REGION [SERVICE_NAME]

set -e

# Check if PROJECT_ID is provided
if [ -z "$1" ]; then
  echo "Usage: ./deploy.sh PROJECT_ID REGION [SERVICE_NAME]"
  echo "Example: ./deploy.sh my-project us-central1 seatify"
  exit 1
fi

PROJECT_ID=$1
REGION=${2:-us-central1}
SERVICE_NAME=${3:-seatify}

echo "========================================"
echo "Deploying Seatify to Google Cloud Run"
echo "========================================"
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"
echo "Service Name: $SERVICE_NAME"
echo "========================================"

# Set the project
echo "Setting Google Cloud project..."
gcloud config set project $PROJECT_ID

# Enable required APIs
echo "Enabling required APIs..."
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Create Artifact Registry repository (ignore error if it already exists)
echo "Creating Artifact Registry repository..."
gcloud artifacts repositories create ${SERVICE_NAME}-repo \
  --repository-format=docker \
  --location=$REGION \
  --description="Docker repository for Seatify" 2>/dev/null || true

# Configure Docker to use Artifact Registry
echo "Configuring Docker for Artifact Registry..."
gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet

# Build the Docker image
echo "Building Docker image..."
docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${SERVICE_NAME}-repo/${SERVICE_NAME}:latest .

# Push to Artifact Registry
echo "Pushing image to Artifact Registry..."
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${SERVICE_NAME}-repo/${SERVICE_NAME}:latest

# Deploy to Cloud Run
echo "Deploying to Cloud Run..."
gcloud run deploy $SERVICE_NAME \
  --image=${REGION}-docker.pkg.dev/${PROJECT_ID}/${SERVICE_NAME}-repo/${SERVICE_NAME}:latest \
  --platform=managed \
  --region=$REGION \
  --allow-unauthenticated \
  --port=8080 \
  --memory=512Mi \
  --cpu=1 \
  --max-instances=10 \
  --set-env-vars="DEBUG=False,SECURE_COOKIES=True"

echo ""
echo "========================================"
echo "Deployment completed successfully!"
echo "========================================"
gcloud run services describe $SERVICE_NAME --region=$REGION --format='value(status.url)'
echo "========================================"
