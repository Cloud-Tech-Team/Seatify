

# Seatify - Classroom Seating Arrangement Generator

Seatify is a web-based platform built using Django and Python that allows users to generate random seating arrangements for classrooms and exams. The platform provides an easy-to-use interface to select branches, semesters, and generate seating arrangements that can be exported as PDFs.

## Features
- Create and manage branches and semesters
- Generate randomized seating arrangements
- Handle absentee students
- Preview seating arrangements
- Download seating arrangements as PDF
- Cloud-ready deployment for Google Cloud Platform

## Tech Stack

### Frontend:
- HTML, CSS, and JavaScript
- Django templates for dynamic rendering
- Modern responsive design

### Backend:
- Django: Python-based web framework
- Database: SQLite (default) or Turso (for production)
- Docker containerization for cloud deployment

### Additional Libraries:
- ReportLab: For generating PDF seating arrangement reports
- Gunicorn: WSGI HTTP server for production
- WhiteNoise: Static file serving for production

## Try it out yourself

### Local Development

1. Clone the repository:
   ```sh
   git clone https://github.com/Cloud-Tech-Team/seatify.git
   cd seatify
   ```

2. Create a virtual environment and activate it:
   ```sh
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install the required Python packages:
   ```sh
   pip install -r requirements.txt
   ```

4. Set up environment variables in `.env`:
   ```
   SECRET_KEY=your-secret-key-here
   DEBUG=True
   ```

5. Run migrations:
   ```sh
   python manage.py migrate
   ```

6. Run the development server:
   ```sh
   python manage.py runserver
   ```

7. Access the application at http://localhost:8000

### Cloud Run Deployment via Artifact Registry

The project includes automated deployment scripts for both Linux/Mac and Windows:

#### Linux/Mac Deployment:
```bash
./deploy.sh PROJECT_ID REGION [SERVICE_NAME]
```

Example:
```bash
./deploy.sh my-gcp-project us-central1 seatify
```

#### Windows Deployment:
```cmd
deploy.bat PROJECT_ID REGION [SERVICE_NAME]
```

Example:
```cmd
deploy.bat my-gcp-project us-central1 seatify
```

#### What the deployment script does:

1. Enables required GCP APIs (Artifact Registry, Cloud Run, Cloud Build)
2. Creates an Artifact Registry repository
3. Builds the Docker image
4. Pushes the image to Artifact Registry
5. Deploys the image to Cloud Run with production settings
6. Makes the service publicly accessible
7. Returns the service URL

### Manual Deployment (Advanced)

If you prefer manual deployment:

1. Enable required APIs:
   ```bash
   gcloud services enable artifactregistry.googleapis.com
   gcloud services enable run.googleapis.com
   gcloud services enable cloudbuild.googleapis.com
   ```

2. Create Artifact Registry repository:
   ```bash
   gcloud artifacts repositories create seatify-repo \
     --repository-format=docker \
     --location=us-central1
   ```

3. Configure Docker for Artifact Registry:
   ```bash
   gcloud auth configure-docker us-central1-docker.pkg.dev
   ```

4. Build and push Docker image:
   ```bash
   docker build -t us-central1-docker.pkg.dev/PROJECT_ID/seatify-repo/seatify:latest .
   docker push us-central1-docker.pkg.dev/PROJECT_ID/seatify-repo/seatify:latest
   ```

5. Deploy to Cloud Run:
   ```bash
   gcloud run deploy seatify \
     --image=us-central1-docker.pkg.dev/PROJECT_ID/seatify-repo/seatify:latest \
     --platform=managed \
     --region=us-central1 \
     --allow-unauthenticated \
     --port=8080 \
     --memory=512Mi \
     --cpu=1 \
     --max-instances=10
   ```

## Environment Variables

- `SECRET_KEY`: Django secret key (required)
- `DEBUG`: Set to `False` in production (default: True)
- `SECURE_COOKIES`: Set to `True` for HTTPS (default: False)
- `USE_TURSO`: Use Turso database instead of SQLite (default: False)
- `TURSO_DATABASE_URL`: Turso database URL (optional)
- `DBAUTHTOKEN`: Turso authentication token (optional)

## Project Structure

```
Seatify/
├── Seatify/              # Django project settings
│   ├── settings.py       # Project configuration
│   ├── urls.py           # Main URL routing
│   └── wsgi.py           # WSGI configuration
├── Seatifyapp/           # Main application
│   ├── models.py         # Database models
│   ├── views.py          # View functions
│   ├── forms.py          # Django forms
│   ├── urls.py           # App URL routing
│   ├── templates/        # HTML templates
│   └── static/           # CSS and static files
├── Dockerfile            # Docker configuration
├── entrypoint.sh         # Docker entrypoint script
├── deploy.sh             # Linux/Mac deployment script
├── deploy.bat            # Windows deployment script
├── requirements.txt      # Python dependencies
└── README.md             # This file
```

## Developers

This project was developed by the following team members:

1. Dhanush P B
2. Johaan Saji
3. Joseph Manoj
4. Tessa Chery
