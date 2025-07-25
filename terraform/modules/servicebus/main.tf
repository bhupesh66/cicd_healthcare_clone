resource "azurerm_servicebus_namespace" "sb" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "queue" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.sb.id
  max_size_in_megabytes = 1024
}

# Diagnostics
resource "azurerm_monitor_diagnostic_setting" "sb_diagnostics" {
  name                       = "servicebus-logs"
  target_resource_id         = azurerm_servicebus_namespace.sb.id
  log_analytics_workspace_id = var.log_analytics_workspace

 enabled_log {
    category = "StorageRead"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

output "connection_string" {
  value = azurerm_servicebus_namespace.sb.default_primary_connection_string
}
