#!/bin/bash

# Exit on any error
set -e

# Check if PROJECT_ID is provided
if [ -z "$1" ]; then
  echo "Usage: ./deploy.sh PROJECT_ID"
  exit 1
fi

PROJECT_ID=$1

echo "Building and deploying Seatify to Cloud Run for project: $PROJECT_ID"

# Build the Docker image
echo "Building Docker image..."
docker build -t gcr.io/$PROJECT_ID/seatify .

# Push to Google Container Registry
echo "Pushing to Google Container Registry..."
gcloud auth configure-docker --quiet
docker push gcr.io/$PROJECT_ID/seatify

# Update the service.yaml file with the project ID
echo "Updating service configuration..."
sed "s/PROJECT_ID/$PROJECT_ID/g" service.yaml > service-deploy.yaml

# Deploy to Cloud Run
echo "Deploying to Cloud Run..."
gcloud run services replace service-deploy.yaml --project=$PROJECT_ID

# Clean up temporary files
rm service-deploy.yaml

echo "Deployment completed successfully!"
echo "To make the service public, run:"
echo "gcloud run services add-iam-policy-binding seatify --member=\"allUsers\" --role=\"roles/run.invoker\" --project=$PROJECT_ID"

# Get the URL of the deployed service
echo "Service URL:"
gcloud run services describe seatify --format 'value(status.url)' --project=$PROJECT_ID
