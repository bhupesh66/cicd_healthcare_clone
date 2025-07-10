env                = "dev"
resource_group_name = "healthcare_project"
workspace_name     = "healthcareworkspace"
cluster_name       = "dev-cluster"
spark_version      = "10.4.x-scala2.12"
node_type_id         = "Standard_D4ds_v5"
min_workers        = 0
max_workers        = 0
location            = "Sweden Central"
environment         = "dev"
workspace           = "healthcareworkspace"
autotermination_minutes = 30
single_node             = true
azure_databricks_workspace_resource_id="/subscriptions/49777150-bb4b-4c70-9175-93ccc9a811d4/resourceGroups/healthcare_project/providers/Microsoft.Databricks/workspaces/healthcareworkspace"
instance_pool_id =null

private_subnet_name          = ""

managed_resource_group_name  = ""
virtual_network_id           = ""

public_subnet_name           = ""

