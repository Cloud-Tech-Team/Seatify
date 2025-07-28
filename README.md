

# Seatify - Classroom Seating Arrangement Generator

Seatify is a web-based platform built using Django and Python that allows teachers to generate random seating arrangements for classrooms. The platform provides an easy-to-use interface for teachers to log in, select the branch and semester, and generate seating arrangements. It also allows teachers to export seating arrangements as PDFs for printing.

## Features
- Teacher login
- Branch and semester selection
- Random seating arrangement generation
- Export seating arrangement as PDF
## Tech Stack
### Frontend:
- HTML, CSS, and JavaScript (with Bootstrap for styling)
- Dynamic rendering with Django templates
- Interactive particle effect using JavaScript Canvas for the registration page

### Backend:
- Django: Python-based web framework
- Database: PostgreSQL or SQLite (depending on the setup)
- Authentication: Django’s built-in authentication system (for user management)

### Additional Libraries:
- Bootstrap: Frontend CSS framework for responsive design
- Bootstrap Icons: For adding icons to UI components.
- ReportLab: For generating dynamic PDFs (like seating arrangement reports)
## Try it out yourself

### Local Development

1. Clone the repository:
    ```sh
    git clone https://github.com/Cloud-Tech-Team/seatify.git
   ``` 

2. Install the required Python packages:
    ```sh
    pip install -r requirements.txt
   ```   

3. Run the server:
    ```sh
    python manage.py runserver
   ```

### Cloud Run Deployment

1. Set up Google Cloud CLI and Docker:
   ```sh
   # Install Google Cloud CLI if not already installed
   # https://cloud.google.com/sdk/docs/install
   
   # Initialize gcloud and set your project
   gcloud init
   gcloud config set project YOUR_PROJECT_ID
   ```

2. Create secrets for your application:
   ```sh
   # Create secrets in Secret Manager
   gcloud secrets create seatify-secrets --data-file=- <<EOL
   {
     "SECRET_KEY": "your-django-secret-key",
     "DBAUTHTOKEN": "your-turso-db-auth-token",
     "TURSO_DATABASE_URL": "your-turso-database-url"
   }
   EOL
   ```

3. Build and push your Docker image:
   ```sh
   # Build the Docker image
   docker build -t gcr.io/YOUR_PROJECT_ID/seatify .
   
   # Push to Google Container Registry
   gcloud auth configure-docker
   docker push gcr.io/YOUR_PROJECT_ID/seatify
   ```

4. Deploy to Cloud Run:
   ```sh
   # Replace PROJECT_ID with your GCP project ID in service.yaml
   sed -i 's/PROJECT_ID/YOUR_PROJECT_ID/g' service.yaml
   
   # Deploy the service
   gcloud run services replace service.yaml
   
   # Allow unauthenticated access (if needed)
   gcloud run services add-iam-policy-binding seatify \
     --member="allUsers" \
     --role="roles/run.invoker"
   ```

5. Access your deployed application:
   ```sh
   # Get the URL of your deployed application
   gcloud run services describe seatify --format 'value(status.url)'
   ```

## Developers
This project was developed by the following team members:

1. Dhanush P B
2. Johaan Saji
3. Joseph Manoj
4. Tessa Chery
