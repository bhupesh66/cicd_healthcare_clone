FROM apache/airflow:2.8.1-python3.10

USER root
# Optional: install any additional OS packages
RUN apt-get update && apt-get install -y \
    git \
    vim \
 && apt-get clean

USER airflow
# Copy DAGs and other configs if needed
COPY ./dags /opt/airflow/dags
COPY ./requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt
