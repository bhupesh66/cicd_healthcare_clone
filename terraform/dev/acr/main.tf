data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "acr" {
  source              = "../../modules/acr"
  acr_name            = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
}

module "network" {
  source              = "../../modules/network"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "container_instance" {
  source              = "../../modules/container_instance"
  prefix              = var.prefix
  location            = var.location
 resource_group_name = data.azurerm_resource_group.rg.name
  acr_login_server    = module.acr.acr_login_server
  docker_image        = var.docker_image
  image_tag           = var.image_tag
  environment_variables =var.environment_variables
  tags                = var.tags
}

output "aci_fqdn" {
  value = module.container_instance.container_fqdn
}