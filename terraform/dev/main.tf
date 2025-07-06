# Tell Terraform which existing resource group to use
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Tell Terraform which existing databricks workspace to use
data "azurerm_databricks_workspace" "workspace" {
  name                = var.workspace_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Get the smallest node type with local disk enabled
data "databricks_node_type" "smallest" {
  depends_on = [data.azurerm_databricks_workspace.workspace]
  local_disk = true
}

# Get the latest Long Term Support spark version
data "databricks_spark_version" "latest_lts" {
  depends_on        = [data.azurerm_databricks_workspace.workspace]
  long_term_support = true
}

# Now call your cluster module, pass these values (do NOT pass empty strings)
module "databricks_cluster" {
  source = "../modules/databricks_workspace"
  
  resource_group_name         = data.azurerm_resource_group.rg.name
  private_subnet_name         = var.private_subnet_name
  location                   = data.azurerm_resource_group.rg.location
  managed_resource_group_name = var.managed_resource_group_name
  virtual_network_id          = var.virtual_network_id
  workspace_name              = data.azurerm_databricks_workspace.workspace.name
  public_subnet_name          = var.public_subnet_name
   
  

  cluster_name    = var.cluster_name
  spark_version   = var.spark_version != "" ? var.spark_version : data.databricks_spark_version.latest_lts.id
  instance_pool_id = var.instance_pool_id
  node_type_id    = var.node_type_id != "" ? var.node_type_id : data.databricks_node_type.smallest.id
  min_workers     = var.min_workers
  max_workers     = var.max_workers
  env             = var.env

  azure_client_id                     = var.azure_client_id
  azure_client_secret                 = var.azure_client_secret
  azure_tenant_id                    = var.azure_tenant_id
  azure_subscription_id                    = var.azure_subscription_id
 
 

  providers = {
    databricks = databricks
  }
  
}
output "cluster_id" {
  value = module.databricks_cluster.cluster_id
}

output "cluster_name" {
  value = module.databricks_cluster.cluster_name
}

output "cluster_state" {
  value = module.databricks_cluster.cluster_state
}

