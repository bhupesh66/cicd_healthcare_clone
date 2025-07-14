resource "random_id" "unique_id" {
  byte_length = 4
}

resource "azurerm_container_group" "aci" {
  name                = "${var.prefix}-aci"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "${var.prefix}-aci-${random_id.unique_id.hex}"
  restart_policy      = "OnFailure"

  container {
    name   = "airflow"
    image  = "${var.acr_login_server}/${var.docker_image}:${var.image_tag}"
    cpu    = 1
    memory = 2

    ports {
      port     = 8080
      protocol = "TCP"
    }

     commands = [
      "/bin/sh",
      "-c",
      "airflow db init && airflow webserver --port 8080"
    ]

    environment_variables = {
      AIRFLOW__CORE__EXECUTOR         = "SequentialExecutor"
      AIRFLOW__CORE__SQL_ALCHEMY_CONN = "sqlite:////root/airflow/airflow.db"
      # Add more if needed, like:
      # AIRFLOW__WEBSERVER__WEB_SERVER_PORT = "8080"
      # AIRFLOW__API__AUTH_BACKENDS = "airflow.api.auth.backend.basic_auth"
      # AIRFLOW__CORE__FERNET_KEY = "your_fernet_key_here"
    }
  }

  image_registry_credential {
    server   = var.acr_login_server
    username = var.acr_username
    password = var.acr_password
  }

  tags = var.tags
}
