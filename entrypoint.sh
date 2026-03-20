#!/bin/bash
set -e

echo "🔄 Running Django migrations..."
python manage.py makemigrations --noinput
python manage.py migrate --noinput

echo "📁 Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "🚀 Starting Gunicorn server..."
exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 Seatify.wsgi:application
