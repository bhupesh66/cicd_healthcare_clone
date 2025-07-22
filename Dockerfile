FROM apache/airflow:2.8.1-python3.10

USER root

# Install extra OS packages
RUN apt-get update && apt-get install -y \
    git \
    vim \
 && apt-get clean

# Create Airflow directories with correct permissions
RUN mkdir -p /opt/airflow/logs /opt/airflow/tmp && chmod -R 777 /opt/airflow

# Set Airflow DB connection string (URL-encoded for special characters like '!')
# Username: airflow_user
# Password: SomeStr0ngPass!
# Host: mynewpgserver12345.postgres.database.azure.com
# Database: airflowdb
ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow_user:SomeStr0ngPass%21@mynewpgserver12345.postgres.database.azure.com:5432/airflowdb?sslmode=require"

# Copy your DAGs and requirements
COPY ./dags /opt/airflow/dags
COPY ./requirements.txt /requirements.txt

# Switch to airflow user for Python package installation
USER airflow

# Install Python dependencies
RUN pip install --no-cache-dir -r /requirements.txt

# Copy entrypoint script and make it executable
COPY --chown=airflow:airflow entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Run Airflow webserver by default
CMD ["airflow", "webserver", "--port", "8080"]
