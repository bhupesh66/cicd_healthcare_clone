data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
}
data "azurerm_container_registry_credentials" "acr_credentials" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
}
