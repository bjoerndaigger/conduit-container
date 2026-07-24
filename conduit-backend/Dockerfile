FROM python:3.6-slim
WORKDIR /app

# psycopg2 lets Python talk to Postgres
# Build it from source since older versions have no ready-made Mac ARM64 package
# libpq-dev is needed both to build it and at runtime (provides the Postgres client library)
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]