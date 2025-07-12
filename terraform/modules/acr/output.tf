output "acr_login_server" {
  value = data.azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = data.azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value     = data.azurerm_container_registry.acr.admin_password
  sensitive = true
}
