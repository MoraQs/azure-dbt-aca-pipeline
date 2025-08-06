# Use a slim Python image for a lightweight container
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /usr/app

# Install dbt-core and the dbt-databricks adapter
# The dbt-databricks adapter is essential for connecting to your Databricks cluster
RUN pip install dbt-core dbt-databricks

# Copy the entire local dbt project folder into the container
# This includes your models, dbt_project.yml, profiles.yml, and other files
COPY ./dbt_project /usr/app/dbt_project

# Copy your Python script for generating models into the container
COPY ./generate_staging_models.py /usr/app/generate_staging_models.py

# Set the entrypoint to a shell. This allows you to run multiple commands,
# such as first generating models and then running dbt.
ENTRYPOINT ["/bin/bash"]