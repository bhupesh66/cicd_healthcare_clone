resource "azurerm_storage_account" "function_sa" {
  name                     = var.function_storage_account
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.function_name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "FunctionApp"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "func" {
  name                       = var.function_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.function_sa.name
  storage_account_access_key = azurerm_storage_account.function_sa.primary_access_key
  version                    = "~4"
  os_type                    = "linux"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME      = "python"
    SERVICEBUS_CONNECTION_STRING  = var.servicebus_connection_string
    SERVICEBUS_QUEUE_NAME         = var.servicebus_queue_name
  }
}

# Diagnostics
resource "azurerm_monitor_diagnostic_setting" "func_diagnostics" {
  name                       = "function-logs"
  target_resource_id         = azurerm_function_app.func.id
  log_analytics_workspace_id = var.log_analytics_workspace

   enabled_log {
    category = "StorageRead"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

output "function_endpoint" {
  value = azurerm_function_app.func.default_hostname
}
