resource "databricks_cluster" "this" {
  cluster_name            = var.cluster_name
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  autotermination_minutes = var.autotermination_minutes

  # Spark config for single-node cluster (dev only)
  spark_conf = var.env == "dev" ? {
    "spark.databricks.cluster.profile" = "singleNode"
    "spark.master"                     = "local[*]"
  } : {}

  # Autoscaling workers for prod only
  dynamic "autoscale" {
    for_each = var.env == "prod" ? [1] : []
    content {
      min_workers = var.min_workers
      max_workers = var.max_workers
    }
  }

  custom_tags = {
    "Environment"   = var.env
    "ResourceClass" = var.env == "dev" ? "SingleNode" : "Standard"
  }

  lifecycle {
    ignore_changes = [instance_pool_id]
  }
}
