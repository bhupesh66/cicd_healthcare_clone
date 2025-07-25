resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Send diagnostics to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "storage_diagnostics" {
  name                       = "storage-logs"
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = var.log_analytics_workspace

  enabled_log {
    category = "StorageRead"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}
