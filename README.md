CI/CD Healthcare Clone 
=================================

Overview
--------
This is a demo project built with Python, Docker, Terraform, and Apache Airflow. 
The goal is to simulate a healthcare data pipeline system, complete with infrastructure 
as code and automated CI/CD pipelines, to showcase deployment, orchestration, 
and workflow integration.

Features
--------
- Infrastructure defined via **Terraform**
- Data pipelines/orchestration with **Airflow DAGs**
- Application logic in **Python** (function‑code)
- Containerization via **Docker**
- Automated workflows via CI/CD (e.g. GitHub Actions)
- Test suite to validate functionality

Project Structure
-----------------
Here’s a typical layout of the repo:

cicd_healthcare_clone/
├── dags/                  # Airflow DAG definitions
├── function-code/         # Python scripts / business logic
├── terraform/             # Terraform configuration files
├── notebooks/             # Experimentation / analysis notebooks
├── test.py                # Test cases / validation script
├── Dockerfile             # Container build instructions
├── entrypoint.sh          # Startup script for container
├── requirements.txt       # Python dependencies
└── .github/workflows/     # CI/CD pipeline definitions

Prerequisites
-------------
- Python 3.10+
- Docker
- Terraform
- Git

Getting Started
---------------
1. Clone the repository and switch to branch `feature1`
   git clone https://github.com/bhupesh66/cicd_healthcare_clone.git
   cd cicd_healthcare_clone
   git checkout feature1

2. Install Python dependencies
   pip install -r requirements.txt

3. Initialize Terraform
   cd terraform
   terraform init
   terraform plan
   terraform apply

4. Build and run Docker container
   docker build -t healthcare-demo .
   docker run --env-file .env healthcare-demo

Running Airflow
---------------
- Move to the `dags/` folder (or the Airflow project root)
- Start Airflow (either using Docker Compose or Airflow CLI)
- Trigger DAGs to run ETL / workflow jobs

Example (if Docker Compose is configured):
   docker-compose up airflow-init
   docker-compose up -d

Testing
-------
Execute tests with:
   pytest test.py

This ensures that your functions, pipelines, and application logic are working as intended.

CI/CD Workflow
--------------
Automated steps include:
- Linting / code checks
- Running tests
- Building Docker images
- Terraform plan / apply phases
- Deploying to target environments

These workflows are defined under `.github/workflows/`.

Contributing
------------
You’re welcome to contribute:
- Fork the repo
- Create a new feature branch
- Make your changes + tests
- Submit a pull request

License
-------
This project is licensed under the **MIT License**.
