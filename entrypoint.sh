#!/bin/bash
set -e

echo "🔄 Running Django migrations..."
python manage.py makemigrations --noinput
python manage.py migrate --noinput

echo "👤 Creating admin user if needed..."
python -c "
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'Seatify.settings')
django.setup()
from django.contrib.auth.models import User
username = 'mitscollegecloud'
email = '23cy036@mgits.ac.in'
password = 'M1TS@Deploy#cloud01'
if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username, email, password)
    print(f'✅ Admin user {username} created successfully!')
else:
    print(f'ℹ️  Admin user {username} already exists')
"

echo "📁 Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "🚀 Starting Gunicorn server..."
exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 Seatify.wsgi:application
