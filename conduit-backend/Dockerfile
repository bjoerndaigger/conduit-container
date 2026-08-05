FROM python:3.6-slim as builder
WORKDIR /app

# psycopg2 lets Python talk to Postgres
# Build it from source since older versions have no ready-made Mac ARM64 package
# libpq-dev is needed both to build it and at runtime (provides the Postgres client library)
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.6-slim
WORKDIR /app

# Only libpq-dev (runtime lib), no build-essential
RUN apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

COPY . .
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]