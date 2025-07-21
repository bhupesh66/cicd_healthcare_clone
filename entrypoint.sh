#!/bin/bash
set -e

# Initialize Airflow DB if not initialized
airflow db init

# Execute the container CMD (e.g. airflow webserver)
exec "$@"
