#!/bin/sh
set -e

python manage.py collectstatic --noinput
python manage.py migrate --noinput

# Django 1.10 has no DJANGO_SUPERUSER env support, so fields are set manually
# Password comes from DJANGO_SUPERUSER_PASSWORD in UserManager
if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_EMAIL" ]; then
    python manage.py createsuperuser --noinput \
        --username "$DJANGO_SUPERUSER_USERNAME" \
        --email "$DJANGO_SUPERUSER_EMAIL" \
        || echo "Superuser already exists — skipping creation."
fi

exec gunicorn --bind 0.0.0.0:8000 conduit.wsgi