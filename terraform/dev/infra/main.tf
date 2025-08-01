

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
  container_name          = ["incoming", "processed", "archive"] # create 3 containers
  log_analytics_workspace = module.log_analytics.workspace_id
}


# Service Bus
module "servicebus" {
  source                  = "../../modules/servicebus"
  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.location
  servicebus_namespace    = var.servicebus_namespace       # ✅ matches input variable
  servicebus_queue        = var.servicebus_queue           # ✅ matches input variable
  log_analytics_workspace = module.log_analytics.workspace_id
}


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
  source                    = "../../modules/functions"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = var.location
  function_name             = var.function_name
  function_storage_account  = var.function_storage_account
  log_analytics_workspace   = module.log_analytics.workspace_id
  storage_connection_string = var.storage_connection_string
  servicebus_connection_string = module.servicebus.servicebus_connection_string
  servicebus_queue_name        = module.servicebus.servicebus_queue_name
  # Removed servicebus_connection_string and servicebus_queue_name
}


# module "eventgrid" {
#   source                  = "../../modules/eventgrid"
#   resource_group_name     = data.azurerm_resource_group.rg.name
#   location                = var.location
#   storage_account_id      = module.storage.storage_account_id
#   function_endpoint       = module.function.function_endpoint
#   container_name          = module.storage.containers["incoming"]
#   function_id             = module.function.function_id
#   log_analytics_workspace = module.log_analytics.workspace_id
#   trigger_name            = "myTrigger1"
#   count                   = var.deploy_eventgrid ? 1 : 0



# }



module "eventgrid" {
  source = "../../modules/eventgrid"

  storage_account_id      = module.storage.storage_account_id
  function_id             = module.function.function_id
  function_endpoint       = replace(module.function.function_endpoint, "https://", "")
  function_name           = "myTrigger1" # Must match your function folder name
  container_name          = "incoming"   # Your target container
  log_analytics_workspace = module.log_analytics.workspace_id
  count                   = var.deploy_eventgrid ? 1 : 0
}