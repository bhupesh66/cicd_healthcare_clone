variable "storage_account_name" {
  type        = string
  description = "Base name for the storage account. A random suffix will be appended."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the storage account will be created."
}

variable "location" {
  type        = string
  description = "Azure location for all resources."
}

variable "container_name" {
  description = "List of container names to create in the storage account"
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace" {
  type        = string
  default     = null
  description = "Optional Log Analytics Workspace ID for diagnostics (set to null to skip)."
}
