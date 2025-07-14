#!/bin/bash
set -e

# Upgrade Airflow DB (migrations)
airflow db upgrade

# You can add other initialization commands here, like creating users

# Run the CMD (airflow webserver ...)
exec "$@"
