output "cluster_id" {
  value       = databricks_cluster.this.id
  description = "ID of the Databricks cluster"
}

output "cluster_name" {
  value       = databricks_cluster.this.cluster_name
  description = "Name of the Databricks cluster"
}

output "cluster_state" {
  value       = databricks_cluster.this.state
  description = "Current state of the Databricks cluster"
}
