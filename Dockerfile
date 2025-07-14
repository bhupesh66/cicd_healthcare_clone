FROM apache/airflow:2.8.1-python3.10

USER root

# Install additional OS packages
RUN apt-get update && apt-get install -y \
    git \
    vim \
 && apt-get clean

USER airflow

# Copy DAGs and requirements
COPY ./dags /opt/airflow/dags
COPY ./requirements.txt /requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /requirements.txt

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]
CMD ["airflow", "webserver", "--port", "8080"]
