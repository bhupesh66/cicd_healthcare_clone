variable "cluster_name" {
  description = "Name for Databricks cluster"
  type        = string
}

variable "spark_version" {
  description = "Databricks Spark version"
  type        = string
}

variable "instance_pool_id" {
  description = "Instance pool ID for Databricks cluster"
  type        = string
  default     = null
}

variable "node_type_id" {
  description = "VM node type ID"
  type        = string
  default     = null
}

variable "min_workers" {
  description = "Minimum number of workers for autoscaling"
  type        = number
}

variable "max_workers" {
  description = "Maximum number of workers for autoscaling"
  type        = number
}

variable "env" {
  description = "Environment (dev or prod)"
  type        = string
}

variable "workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

variable "location" {
  description = "Azure region for the Databricks workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "managed_resource_group_name" {
  description = "Name of the managed resource group for Databricks"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network"
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
  type        = string
}

variable "azure_client_id" {
  description = "Azure client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure client secret"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "single_node" {
  description = "Whether to create a single node cluster"
  type        = bool
  default     = false
}


variable "autotermination_minutes" {
  description = "Number of workers (only used if not single node)"
  type        = number
  default     = 1
}



