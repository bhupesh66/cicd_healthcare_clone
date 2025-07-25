resource "azurerm_eventgrid_event_subscription" "file_sub" {
  name  = "file-upload-subscription"
  scope = var.storage_account_id

  event_delivery_schema = "EventGridSchema"
  included_event_types  = ["Microsoft.Storage.BlobCreated"]

  # Trigger Azure Function
  azure_function_endpoint {
    function_id = "${var.function_endpoint}/functions/<YourFunctionName>"
  }
}

# Diagnostics
resource "azurerm_monitor_diagnostic_setting" "eventgrid_diagnostics" {
  name                       = "eventgrid-logs"
  target_resource_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace

   enabled_log {
    category = "StorageRead"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}
