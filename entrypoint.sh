#!/bin/bash
set -e

# Initialize Airflow DB schema and create default connections
airflow db migrate
airflow connections create-default-connections

# Execute the container CMD (e.g. airflow webserver)
exec "$@"
