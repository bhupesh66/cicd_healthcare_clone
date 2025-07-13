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
  restart_policy      = "OnFailure"  # Ok but consider "Always" if you want the container always running

  container {
    name   = "airflow"
    image  = "${var.acr_login_server}/${var.docker_image}:${var.image_tag}"
    cpu    = 1
    memory = 2

    ports {
      port     = 8080
      protocol = "TCP"
    }

    environment_variables = var.environment_variables  # Make sure this is a map(string) with your env vars
  }

  image_registry_credential {
    server   = var.acr_login_server
    username = var.acr_username
    password = var.acr_password
  }

  tags = var.tags
}
