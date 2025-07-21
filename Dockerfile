FROM apache/airflow:2.8.1-python3.10

USER root

# Install extra OS packages
RUN apt-get update && apt-get install -y \
    git \
    vim \
 && apt-get clean

# Create Airflow directories with correct permissions
RUN mkdir -p /opt/airflow/logs /opt/airflow/tmp && chmod -R 777 /opt/airflow

# Set Airflow DB connection string environment variable
ENV AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://pgadmin:StrongP@ssw0rd123@mypgserver1753137250.postgres.database.azure.com:5432/airflowdb"

# Copy your DAGs and requirements.txt
COPY ./dags /opt/airflow/dags
COPY ./requirements.txt /requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /requirements.txt

# Copy entrypoint script and make executable as root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to airflow user only after setting permissions
USER airflow

ENTRYPOINT ["/entrypoint.sh"]
CMD ["airflow", "webserver", "--port", "8080"]
