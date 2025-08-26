FROM python:3.12-slim

WORKDIR /usr/app/adventureworks

# Install bash and other required packages
RUN apt-get update && \
    apt-get install -y bash && \
    pip install dbt-core==1.10.9 dbt-databricks==1.10.10 && \
    apt-get install -y git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./adventureworks /usr/app/adventureworks

# Point dbt to the profiles directory
ENV DBT_PROFILES_DIR=/usr/app/adventureworks

CMD [ "bash" ]