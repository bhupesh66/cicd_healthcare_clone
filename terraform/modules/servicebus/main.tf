resource "azurerm_servicebus_namespace" "sb" {
  name                = var.servicebus_namespace
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "queue" {
  name         = var.servicebus_queue
  namespace_id = azurerm_servicebus_namespace.sb.id
  
}

resource "azurerm_servicebus_namespace_authorization_rule" "send" {
  name          = "SendRule"
  namespace_id  = azurerm_servicebus_namespace.sb.id

  listen        = false
  send          = true
  manage        = false
}


resource "azurerm_monitor_diagnostic_setting" "sb_diagnostics" {
  name                       = "servicebus-logs"
  target_resource_id         = azurerm_servicebus_namespace.sb.id
  log_analytics_workspace_id = var.log_analytics_workspace

  # Only use supported categories
  enabled_log {
    category = "OperationalLogs"
  }

  enabled_log {
    category = "RuntimeAuditLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

output "servicebus_connection_string" {
  value     = azurerm_servicebus_namespace_authorization_rule.send.primary_connection_string
  sensitive = true
}

output "servicebus_queue_name" {
  value = azurerm_servicebus_queue.queue.name
}
