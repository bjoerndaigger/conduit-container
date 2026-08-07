# Conduit Container

Containerized full-stack version of the **Conduit ([RealWorld](https://github.com/gothinkster/realworld))** demo application. This repository combines an Angular frontend, a Django REST backend, and a PostgreSQL database into a single Docker Compose setup that can be started with one command.

The repository contains:

* **Angular frontend** served by nginx
* **Django REST backend** served by Gunicorn
* **PostgreSQL database**
* **Docker Compose** configuration to orchestrate all services
* **Environment template** (`.env.template`) for application configuration

The purpose of this repository is to provide a reproducible local development environment with minimal setup while allowing the application to be configured through environment variables.

---

# Table of Contents

* [Quickstart](#quickstart)
* [Usage](#usage)
  * [Configuration](#configuration)
  * [Changing the API URL](#changing-the-api-url)
  * [Changing Ports](#changing-ports)
  * [Docker Logs](#docker-logs)
* [Project Structure](#project-structure)

---

# Quickstart

## Prerequisites

* Docker
* Docker Compose (v2)

## Setup
```bash
git clone https://github.com/bjoerndaigger/conduit-container.git
cd conduit-container
cp .env.template .env
```

## Start the application
```bash
docker compose up --build
```

After the containers have started, the application is available at:

| Service      | URL                                |
| ------------ | ----------------------------------- |
| Frontend     | `http://<host>:8282`                |
| Backend API  | `http://<host>:8000/api`            |
| Django Admin | `http://<host>:8000/admin`          |

Replace `<host>` with `localhost` (local setup) or your server's domain/IP (remote deployment).

Stop the application with:

```bash
docker compose down
```

---

# Usage

## Configuration

The application is configured through the `.env` file. Copy `.env.template` to `.env` and adjust the values as required.

The most relevant variables are:

| Variable                | Purpose                             |
| ----------------------- | ----------------------------------- |
| `POSTGRES_*`            | Database configuration              |
| `DJANGO_SECRET_KEY`     | Django secret key                   |
| `DJANGO_DEBUG`          | Enable or disable debug mode        |
| `DJANGO_ALLOWED_HOSTS`  | Allowed backend hosts               |
| `CORS_ORIGIN_WHITELIST` | Allowed frontend origins            |
| `DJANGO_SUPERUSER_*`    | Automatically created administrator |
| `API_URL`               | Backend URL used by the frontend    |

For production deployments, set `DJANGO_DEBUG=False` and replace all example credentials with secure values.

## Changing the API URL

The frontend receives the backend URL during the image build.

To use another backend endpoint:

1. Change `API_URL` in `.env`.
2. Rebuild the frontend image.

```bash
docker compose up --build frontend
```

## Changing Ports

Published ports are configured in `docker-compose.yaml`.

Example:

```yaml
frontend:
  ports:
    - "8282:80"

backend:
  ports:
    - "8000:8000"

database:
  ports:
    - "5432:5432"
```

Only the left value (host port) needs to be changed. If the frontend port changes, update `CORS_ORIGIN_WHITELIST` accordingly. If the backend port changes, update `API_URL` as well.

## Docker Logs

Docker Compose provides access to the logs of all running services.

Show logs of all services:

```bash
docker compose logs
```

Show logs of a single service:

```bash
docker compose logs frontend
docker compose logs backend
docker compose logs database
```

Follow the logs in real time (stop with <kbd>Ctrl</kbd>+<kbd>C</kbd>):

```bash
docker compose logs -f backend
```

Save the logs of a service to a file:

```bash
docker compose logs backend > conduit-backend-logs.txt
```

---

# Project Structure

```text
conduit-container/
├── conduit-backend/        # Django REST backend
├── conduit-frontend/       # Angular frontend
├── docker-compose.yaml     # Service orchestration
├── .env.template           # Environment variable template
└── README.md
```
