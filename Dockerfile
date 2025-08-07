FROM python:3.12-slim

WORKDIR /usr/app

# Install bash and other required packages
RUN apt-get update && \
    apt-get install -y bash && \
    pip install dbt-core dbt-databricks && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./adventureworks /usr/app/adventureworks
COPY ./scripts/generate_staging_models.py /usr/app/scripts/generate_staging_models.py
COPY ./sources_manifest.json /usr/app/sources_manifest.json

CMD [ "bash" ]