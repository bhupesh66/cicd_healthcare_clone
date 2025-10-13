#!/bin/bash
set -e

# Initialize Airflow DB schema (safe even if already initialized)
airflow db migrate

# Start scheduler in the background
airflow scheduler &

# Start webserver (keeps the container running)
exec airflow webserver --port 8080
