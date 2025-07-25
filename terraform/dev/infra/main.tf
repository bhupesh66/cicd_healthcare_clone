

# Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name

}

# Log Analytics
module "log_analytics" {
  source              = "../../modules/log_analytics"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  workspace_name      = var.log_analytics_workspace_name
}

# ADLS Gen2
module "storage" {
  source                  = "../../modules/storage"
  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.location
  storage_account_name    = var.storage_account_name
  container_name          = var.container_name
  log_analytics_workspace = module.log_analytics.workspace_id
}

# Service Bus
# module "servicebus" {
#   source                  = "../../modules/servicebus"
#   resource_group_name     = data.azurerm_resource_group.rg.name
#   location                = var.location
#   namespace_name          = var.servicebus_namespace
#   queue_name              = var.servicebus_queue
#   log_analytics_workspace = module.log_analytics.workspace_id
# }

# Azure Function (to process files)
# module "function" {
#   source                       = "../../modules/functions"
#   resource_group_name          = data.azurerm_resource_group.rg.name
#   location                     = var.location
#   function_name                = var.function_name
#   function_storage_account     = var.function_storage_account
#   log_analytics_workspace      = module.log_analytics.workspace_id
#   servicebus_connection_string = module.servicebus.connection_string
#   servicebus_queue_name        = var.servicebus_queue
# }

module "function" {
  source                   = "../../modules/functions"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  function_name            = var.function_name
  function_storage_account = var.function_storage_account
  log_analytics_workspace  = module.log_analytics.workspace_id
  # Removed servicebus_connection_string and servicebus_queue_name
}


module "eventgrid" {
  source                  = "../../modules/eventgrid"
  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.location
  storage_account_id      = module.storage.storage_account_id
  function_endpoint       = module.function.function_endpoint
  function_id             = module.function.function_id
  log_analytics_workspace = module.log_analytics.workspace_id

}



