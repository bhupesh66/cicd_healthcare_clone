variable "resource_group_name" {}
variable "location" { default = "Sweden Central" }

variable "log_analytics_workspace_name" { default = "central-law" }

variable "storage_account_name" {}
variable "container_name" { default = "rawdata" }

variable "servicebus_namespace" {}
variable "servicebus_queue" { default = "airflowqueue" }

variable "function_name" {}
variable "function_storage_account" { type = string }

variable "AZURE_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure Subscription ID"
}

variable "ACR_CLIENT_ID" {
  type        = string
  description = "Azure Container Registry client ID"
}

variable "ACR_CLIENT_SECRET" {
  type        = string
  description = "Azure Container Registry client secret"
}

variable "ACR_TENANT_ID" {
  type        = string
  description = "Azure Tenant ID"
}

variable "function_endpoint" {
  type = string
}

# OR

variable "function_id" {
  type = string
}
variable "deploy_eventgrid" {
  type    = bool
  default = true
}

