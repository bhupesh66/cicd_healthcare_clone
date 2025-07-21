FROM apache/airflow:2.8.1-python3.10

USER root

# Install additional OS packages
RUN apt-get update && apt-get install -y \
    git \
    vim \
 && apt-get clean

# Ensure Airflow directories exist and have correct permissions
RUN mkdir -p /opt/airflow/logs /opt/airflow/tmp && chmod -R 777 /opt/airflow

USER airflow

# Copy DAGs and requirements
COPY ./dags /opt/airflow/dags
COPY ./requirements.txt /requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /requirements.txt

# Copy the entrypoint script (make sure it's executable on your host)
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["airflow", "webserver", "--port", "8080"]
