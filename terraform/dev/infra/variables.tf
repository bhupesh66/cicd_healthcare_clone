variable "resource_group_name" {}
variable "location" { default = "Sweden Central" }

variable "log_analytics_workspace_name" {}

variable "storage_account_name" {}


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
variable "deploy_eventgrid" {
  type    = bool
  default = true
}

variable "container_name" {
  type        = string
  description = "The name of the blob storage container where incoming files land."

}

variable "function_id" {
  type        = string
  description = "Resource ID of the Azure Function to trigger."
}





