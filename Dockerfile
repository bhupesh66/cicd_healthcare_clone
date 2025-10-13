FROM apache/airflow:2.8.1-python3.10

USER root

RUN apt-get update && apt-get install -y \
    git \
    vim \
 && apt-get clean

RUN mkdir -p /opt/airflow/logs /opt/airflow/tmp && chmod -R 777 /opt/airflow

ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow_user:SomeStr0ngPass%21@mynewpgserver12345.postgres.database.azure.com:5432/airflowdb?sslmode=require"

COPY ./dags /opt/airflow/dags
COPY ./requirements.txt /requirements.txt

USER airflow
RUN pip install --no-cache-dir -r /requirements.txt

COPY --chown=airflow:airflow entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
