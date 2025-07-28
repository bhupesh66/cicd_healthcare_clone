resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_storage_account" "storage" {
  name                     = "${substr(var.storage_account_name, 0, 12)}${random_id.suffix.hex}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

# Create multiple containers dynamically
resource "azurerm_storage_container" "containers" {
  for_each = toset(var.container_name)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Only create diagnostics if a workspace is provided
resource "azurerm_monitor_diagnostic_setting" "storage_diag" {
  count                      = var.log_analytics_workspace != null ? 1 : 0
  name                       = "storage-diagnostics"
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = var.log_analytics_workspace

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Outputs for reuse
output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "containers" {
  value = { for name, container in azurerm_storage_container.containers : name => container.name }
}
