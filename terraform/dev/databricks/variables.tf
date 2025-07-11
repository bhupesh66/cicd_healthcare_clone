variable "env" {
  description = "Environment (dev or prod)"
  type        = string
}



variable "workspace_name" {
  description = "Existing Databricks workspace name"
  type        = string
}

variable "cluster_name" {
  description = "Name for Databricks cluster"
  type        = string
}

variable "spark_version" {
  description = "Databricks Spark version"
  type        = string
}



variable "min_workers" {
  description = "Minimum number of workers for autoscaling"
  type        = number
}

variable "max_workers" {
  description = "Maximum number of workers for autoscaling"
  type        = number
}
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}
variable "workspace" {
  description = "workspace name"
  type= string
}
variable "azure_client_id" {
    type=string
  
}

variable "azure_client_secret" {
    type=string
  
}

variable "azure_tenant_id" {
    type=string
  
}
variable "azure_subscription_id" {
    type=string
  
}

variable "azure_databricks_workspace_resource_id"{
  type=string
}

variable "instance_pool_id" {
  type=string
  
}

variable "node_type_id"{
  type=string
}





variable "managed_resource_group_name" {
  description = "Name of the managed resource group for Databricks."
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network."
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the public subnet."
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private subnet."
  type        = string
}
variable "single_node" {
  description = "Whether to use a single-node cluster"
  type        = bool
  default     = false
}

variable "autotermination_minutes" {
  description = "Number of workers (only used if not single node)"
  type        = number
  default     = 1
}
