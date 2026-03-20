@echo off
REM Deployment script for Seatify to Google Cloud Run via Artifact Registry
REM Usage: deploy.bat PROJECT_ID REGION [SERVICE_NAME]

if "%~1"=="" (
    echo Usage: deploy.bat PROJECT_ID REGION [SERVICE_NAME]
    echo Example: deploy.bat my-project us-central1 seatify
    exit /b 1
)

set PROJECT_ID=%~1
set REGION=%~2
set SERVICE_NAME=%~3

REM Default service name if not provided
if "%SERVICE_NAME%"=="" set SERVICE_NAME=seatify

REM Default region if not provided
if "%REGION%"=="" set REGION=us-central1

echo ========================================
echo Deploying Seatify to Google Cloud Run
echo ========================================
echo Project ID: %PROJECT_ID%
echo Region: %REGION%
echo Service Name: %SERVICE_NAME%
echo ========================================

REM Set the project
echo Setting Google Cloud project...
gcloud config set project %PROJECT_ID%

REM Enable required APIs
echo Enabling required APIs...
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com

REM Create Artifact Registry repository (ignore error if it already exists)
echo Creating Artifact Registry repository...
gcloud artifacts repositories create %SERVICE_NAME%-repo --repository-format=docker --location=%REGION% --description="Docker repository for Seatify" 2>nul

REM Configure Docker to use Artifact Registry
echo Configuring Docker for Artifact Registry...
gcloud auth configure-docker %REGION%-docker.pkg.dev --quiet

REM Build the Docker image
echo Building Docker image...
docker build -t %REGION%-docker.pkg.dev/%PROJECT_ID%/%SERVICE_NAME%-repo/%SERVICE_NAME%:latest .

if errorlevel 1 (
    echo Docker build failed!
    exit /b 1
)

REM Push to Artifact Registry
echo Pushing image to Artifact Registry...
docker push %REGION%-docker.pkg.dev/%PROJECT_ID%/%SERVICE_NAME%-repo/%SERVICE_NAME%:latest

if errorlevel 1 (
    echo Docker push failed!
    exit /b 1
)

REM Deploy to Cloud Run
echo Deploying to Cloud Run...
gcloud run deploy %SERVICE_NAME% ^
    --image=%REGION%-docker.pkg.dev/%PROJECT_ID%/%SERVICE_NAME%-repo/%SERVICE_NAME%:latest ^
    --platform=managed ^
    --region=%REGION% ^
    --allow-unauthenticated ^
    --port=8080 ^
    --memory=512Mi ^
    --cpu=1 ^
    --max-instances=10 ^
    --set-env-vars="DEBUG=False,SECURE_COOKIES=True"

if errorlevel 1 (
    echo Deployment failed!
    exit /b 1
)

REM Get service URL
echo.
echo ========================================
echo Deployment completed successfully!
echo ========================================
gcloud run services describe %SERVICE_NAME% --region=%REGION% --format="value(status.url)"
echo ========================================
