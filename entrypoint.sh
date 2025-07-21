#!/bin/bash
set -e

# Initialize the Airflow database (if it doesn't exist)
airflow db init || true

# Start scheduler in the background
airflow scheduler &

# Start webserver
exec "$@"
