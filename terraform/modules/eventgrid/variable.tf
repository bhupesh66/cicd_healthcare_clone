# variable "storage_account_id" {
#   type = string
# }
# variable "function_endpoint" {
#   type = string
# }
# variable "log_analytics_workspace" {
#   type = string
# }
# variable "resource_group_name" {}
# variable "location" {}

# variable "container_name" {
#   type        = string
#   description = "Name of the storage container to filter on"
# }


variable "function_id" {
  type        = string
  description = "Resource ID of the Function App"
}

variable "function_endpoint" {
  type        = string
  description = "Function App hostname (without protocol)"
}

variable "function_name" {
  type        = string
  description = "Name of the specific function to trigger"
  default     = "myTrigger1" # Default matches your function folder name
}

variable "container_name" {
  type        = string
  description = "Name of the storage container to monitor"
}

variable "storage_account_id" {
  type        = string
  description = "The full resource ID of the storage account to monitor"
}

variable "log_analytics_workspace" {
  type = string
}