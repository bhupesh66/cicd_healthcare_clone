FROM apache/airflow:2.8.1-python3.10

USER root

# Install extra OS packages
RUN apt-get update && apt-get install -y \
    git \
    vim \
 && apt-get clean

# Create Airflow directories with correct permissions
RUN mkdir -p /opt/airflow/logs /opt/airflow/tmp && chmod -R 777 /opt/airflow

# Set Airflow DB connection string environment variable (correct format)
ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://pgadmin%40mypgserver1753137250:NewStrongPassword123%21@mypgserver1753137250.postgres.database.azure.com:5432/airflowdb?sslmode=require"


# Copy your DAGs and requirements.txt
COPY ./dags /opt/airflow/dags
COPY ./requirements.txt /requirements.txt

# Switch to airflow user for pip install and entrypoint permission
USER airflow

# Install Python dependencies as airflow user
RUN pip install --no-cache-dir -r /requirements.txt

# Copy entrypoint script and make executable as airflow user
COPY --chown=airflow:airflow entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["airflow", "webserver", "--port", "8080"]
