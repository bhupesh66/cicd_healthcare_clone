
resource_group_name = "healthcare_project"
location            = "Sweden Central"
acr_name            = "acrairflowdevhealthcare"
prefix              = "airflowdev"
docker_image        = "airflow"
image_tag           = "latest"
environment_variables= {}
tags = {
  environment = "dev"
  project     = "airflow"
}
