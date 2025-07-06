terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.34.0"
    }
  }
}

resource "databricks_cluster" "this" {
  cluster_name  = var.cluster_name
  spark_version = var.spark_version

  # Use instance_pool_id only for prod, else null
  instance_pool_id = var.env == "prod" ? var.instance_pool_id : null

  # Use node_type_id only for dev, else null
  node_type_id = var.env == "dev" ? var.node_type_id : null

  autoscale {
    min_workers = var.min_workers
    max_workers = var.max_workers
  }

  lifecycle {
    ignore_changes = [instance_pool_id]
  }
}
